import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/services/dosen/api_config.dart';

class ApiDashboard {

  Future<int> getTotalKegiatanJTI() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/total-kegiatan-jti'),
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
        Uri.parse('${ApiConfig.baseUrl}/dashboard-dosen/total-kegiatan-non-jti'),
      );
      final data = json.decode(response.body);
      return data['data'] as int;
    } catch (e) {
      throw Exception('Failed to load total kegiatan non JTI: $e');
    }
  }
}