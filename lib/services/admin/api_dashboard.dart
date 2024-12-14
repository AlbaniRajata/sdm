import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdm/models/admin/dashboard_model.dart';

class ApiDashboard {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiDashboard({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<DashboardModel> getDashboardData() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dashboard data respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final Map<String, dynamic> dashboardData = {
            'total_dosen': jsonResponse['data']['total_dosen'],
            'total_kegiatan': jsonResponse['data']['total_kegiatan'],
            'total_kegiatan_jti': jsonResponse['data']['total_kegiatan_jti'],
            'total_kegiatan_non_jti': jsonResponse['data']['total_kegiatan_non_jti'],
          };

          return DashboardModel.fromJson(dashboardData);
        }
        throw Exception(jsonResponse['message'] ?? 'Gagal memuat data dashboard');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat data dashboard';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error di getDashboardData: $e');
      rethrow;
    }
  }

  Future<int> getTotalDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Total Dosen respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return jsonResponse['data'] as int;
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat total dosen';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error di getTotalDosen: $e');
      rethrow;
    }
  }

  Future<int> getTotalKegiatanJTI() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Total Kegiatan JTI respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return jsonResponse['data'] as int;
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat total kegiatan JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error di getTotalKegiatanJTI: $e');
      rethrow;
    }
  }

  Future<int> getTotalKegiatanNonJTI() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan-non-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Total Kegiatan Non JTI respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return jsonResponse['data'] as int;
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat total kegiatan non JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error di getTotalKegiatanNonJTI: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTotalKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Total Kegiatan respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return jsonResponse['data'];
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat total kegiatan';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error di getTotalKegiatan: $e');
      rethrow;
    }
  }
}