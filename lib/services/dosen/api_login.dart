import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/dosen/user.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiLogin {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiLogin({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<void> _persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    this.token = token;
  }

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<Map<String, dynamic>> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      debugPrint('Login response status: ${response.statusCode}');
      debugPrint('Login response body: ${response.body}');

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['token'] != null) {
        await _persistToken(responseData['token']);
        
        // Return user data along with token
        return {
          'status': true,
          'message': 'Login successful',
          'data': {
            'token': responseData['token'],
            'user': responseData['user'],  // Assuming the API returns user data
          }
        };
      } else if (response.statusCode == 401) {
        return {
          'status': false,
          'message': responseData['error'] ?? 'Authentication failed',
        };
      } else {
        return {
          'status': false,
          'message': responseData['error'] ?? 'Failed to login',
        };
      }
    } catch (e) {
      debugPrint('Error in login: $e');
      return {
        'status': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  Future<bool> logout() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return true; // Already logged out
      }

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        this.token = null;
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error in logout: $e');
      return false;
    }
  }

  Future<http.Response> getData(String endpoint) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      return await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      debugPrint('Error in getData: $e');
      rethrow;
    }
  }

  Future<http.Response> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      return await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      debugPrint('Error in postData: $e');
      rethrow;
    }
  }
}