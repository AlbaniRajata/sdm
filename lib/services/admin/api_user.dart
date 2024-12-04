import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/user_response.dart';
import 'package:sdm/services/admin/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUserAdmin {
  String? token;

  ApiUserAdmin({this.token});

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<UserResponse> getUsers() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token not available');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('GetUsers Response: ${response.body}');
      
      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getUsers: $e');
      rethrow;
    }
  }

  Future<UserResponse> getUserDetail(int userId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token not available');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user detail: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getUserDetail: $e');
      rethrow;
    }
  }

  Future<UserResponse> createUser({
    required String username,
    required String nama,
    required String tanggalLahir,
    required String email,
    required String password,
    required String nip,
    required String level,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token not available');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'nama': nama,
          'tanggal_lahir': tanggalLahir,
          'email': email,
          'password': password,
          'NIP': nip,
          'level': level,
        }),
      );

      if (response.statusCode == 201) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in createUser: $e');
      rethrow;
    }
  }

  Future<UserResponse> updateUser({
    required int userId,
    required String username,
    required String nama,
    required String tanggalLahir,
    required String email,
    required String nip,
    required String level,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token not available');

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'nama': nama,
          'tanggal_lahir': tanggalLahir,
          'email': email,
          'NIP': nip,
          'level': level,
        }),
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in updateUser: $e');
      rethrow;
    }
  }

  Future<UserResponse> deleteUser(int userId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token not available');

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in deleteUser: $e');
      rethrow;
    }
  }
}