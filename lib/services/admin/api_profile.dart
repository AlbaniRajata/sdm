import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProfile {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiProfile({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<UserModel> updateProfile(int id, {
    required String nama,
    required String email,
    String? nip,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final Map<String, dynamic> data = {
        'nama': nama,
        'email': email,
        'NIP': nip,
      };

      if (oldPassword != null && newPassword != null && confirmPassword != null) {
        data['old_password'] = oldPassword;
        data['new_password'] = newPassword;
        data['confirm_password'] = confirmPassword;
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/user-admin/users/$id/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      debugPrint('Update Profile response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return UserModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Gagal memperbarui profil');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else if (response.statusCode == 422) {
        final jsonResponse = json.decode(response.body);
        throw Exception(jsonResponse['message'] ?? 'Kesalahan validasi');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Gagal memperbarui profil'
        );
      }
    } catch (e) {
      debugPrint('Error di updateProfile: $e');
      rethrow;
    }
  }
}