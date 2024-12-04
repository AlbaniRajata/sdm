import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/models/admin/jabatan_kegiatan_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class ApiJabatanKegiatan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiJabatanKegiatan({this.token});

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Mengambil semua data jabatan kegiatan
  Future<List<JabatanKegiatan>> getAllJabatanKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching jabatan kegiatan with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/jabatan-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final JabatanKegiatanResponse jabatanResponse = 
            JabatanKegiatanResponse.fromJson(json.decode(response.body));
        return jabatanResponse.jabatanKegiatanList;
      } else {
        throw Exception('Failed to load jabatan kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getAllJabatanKegiatan: $e');
      rethrow;
    }
  }

  // Membuat jabatan kegiatan baru
  Future<JabatanKegiatan> createJabatanKegiatan({
    required String jabatanNama,
    required double poin,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/jabatan-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'jabatan_nama': jabatanNama,
          'poin': poin,
        }),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final JabatanKegiatanResponse jabatanResponse = 
            JabatanKegiatanResponse.fromJson(json.decode(response.body));
        final jabatan = jabatanResponse.jabatanKegiatan;
        if (jabatan == null) {
          throw Exception('Failed to create jabatan kegiatan');
        }
        return jabatan;
      } else {
        throw Exception('Failed to create jabatan kegiatan');
      }
    } catch (e) {
      debugPrint('Error in createJabatanKegiatan: $e');
      rethrow;
    }
  }

  // Mengupdate jabatan kegiatan
  Future<JabatanKegiatan> updateJabatanKegiatan({
    required int id,
    required String jabatanNama,
    required double poin,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/jabatan-kegiatan/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'jabatan_nama': jabatanNama,
          'poin': poin,
        }),
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final JabatanKegiatanResponse jabatanResponse = 
            JabatanKegiatanResponse.fromJson(json.decode(response.body));
        final jabatan = jabatanResponse.jabatanKegiatan;
        if (jabatan == null) {
          throw Exception('Failed to update jabatan kegiatan');
        }
        return jabatan;
      } else {
        throw Exception('Failed to update jabatan kegiatan');
      }
    } catch (e) {
      debugPrint('Error in updateJabatanKegiatan: $e');
      rethrow;
    }
  }

  // Menghapus jabatan kegiatan
  Future<bool> deleteJabatanKegiatan(int id) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/jabatan-kegiatan/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final JabatanKegiatanResponse jabatanResponse = 
            JabatanKegiatanResponse.fromJson(json.decode(response.body));
        return jabatanResponse.status;
      } else {
        throw Exception('Failed to delete jabatan kegiatan');
      }
    } catch (e) {
      debugPrint('Error in deleteJabatanKegiatan: $e');
      rethrow;
    }
  }
}