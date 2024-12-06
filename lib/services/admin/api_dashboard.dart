// lib/services/admin/api_dashboard.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/services/admin/api_config.dart';

class ApiDashboard {
  Future<int> getTotalDosen() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-dosen'),
      );
      final data = json.decode(response.body);
      return data['data'] as int;
    } catch (e) {
      throw Exception('Failed to load total dosen: $e');
    }
  }

  Future<int> getTotalKegiatanJTI() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan-jti'),
      );
      final data = json.decode(response.body);
      return data['data'] as int;
    } catch (e) {
      throw Exception('Failed to load total kegiatan: $e');
    }
  }

  Future<int> getTotalKegiatanNonJTI() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-admin/total-kegiatan-non-jti'),
      );
      final data = json.decode(response.body);
      return data['data'] as int;
    } catch (e) {
      throw Exception('Failed to load total kegiatan non JTI: $e');
    }
  }
}