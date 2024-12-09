// api_dosen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdm/models/dosen/dosen_model.dart';

class ApiDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiDosen({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<DosenModel>> getJabatanKegiatan(int idUser) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/dosen-jabatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'id_user': idUser.toString(),
        },
      );

      debugPrint('Jabatan Kegiatan response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> jabatanKegiatanData = jsonResponse['jabatan_kegiatan'];
          return jabatanKegiatanData.map((json) => DosenModel.fromJson(json)).toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data not found'
            : json.decode(response.body)['message'] ?? 'Failed to load jabatan kegiatan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getJabatanKegiatan: $e');
      rethrow;
    }
  }
}