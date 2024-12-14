import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sdm/models/dosen/dashboard_model.dart';

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
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/total-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dashboard data response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final Map<String, dynamic> dashboardData = {
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

  Future<DashboardModel> getDashboardPIC() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/pic'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dashboard data response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final Map<String, dynamic> dashboardData = {
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
      debugPrint('Error di getDashboardPIC: $e');
      rethrow;
    }
  }

  Future<DashboardModel> getDashboardAnggota() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/anggota'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dashboard data response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final Map<String, dynamic> dashboardData = {
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
      debugPrint('Error di getDashboardAnggota: $e');
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
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/total-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Total Kegiatan response: ${response.body}');

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