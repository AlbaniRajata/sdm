import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/user.dart';
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
      // Validasi input kosong
      if (user.username.isEmpty) {
        return {
          'status': false,
          'message': 'Username harus diisi',
        };
      }

      if (user.password.isEmpty) {
        return {
          'status': false,
          'message': 'Password harus diisi',
        };
      }

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
        if (responseData['user'] != null) {
          final userData = responseData['user'];
          final String userLevel = userData['level']?.toString().toLowerCase() ?? '';

          if (userLevel != 'admin') {
            return {
              'status': false,
              'message': 'Username tidak terdaftar sebagai Admin',
            };
          }

          await _persistToken(responseData['token']);
          
          return {
            'status': true,
            'message': 'Login berhasil',
            'data': {
              'token': responseData['token'],
              'user': userData,
            }
          };
        } else {
          return {
            'status': false,
            'message': 'Data pengguna tidak valid',
          };
        }
      } else if (response.statusCode == 401) {
        final errorMessage = responseData['error']?.toString().toLowerCase() ?? '';
        
        if (errorMessage.contains('username')) {
          return {
            'status': false,
            'message': 'Username yang Anda masukkan salah',
          };
        } else if (errorMessage.contains('password')) {
          return {
            'status': false,
            'message': 'Password yang Anda masukkan salah',
          };
        }

        return {
          'status': false,
          'message': 'Username atau password salah',
        };
      } else {
        return {
          'status': false,
          'message': 'Gagal melakukan login. Silakan coba lagi',
        };
      }
    } on SocketException {
      return {
        'status': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda',
      };
    } catch (e) {
      debugPrint('Error dalam login: $e');
      return {
        'status': false,
        'message': 'Terjadi kesalahan yang tidak terduga',
      };
    }
  }

  Future<bool> logout() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return true;
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