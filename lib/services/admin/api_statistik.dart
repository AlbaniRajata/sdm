import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/statistik_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiStatistikAdmin {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiStatistikAdmin({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<StatistikAdmin>> getStatistikAdmin() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/statistik-admin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Statistik Admin response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body directly as a list
        final List<dynamic> statistikList = json.decode(response.body);
        
        return statistikList.map((item) {
          try {
            // Handle null values and type conversion
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? '',
              totalKegiatan: item['total_kegiatan'] is int 
                  ? item['total_kegiatan'] 
                  : int.tryParse(item['total_kegiatan']?.toString() ?? '0') ?? 0,
              totalPoin: item['total_poin'] == null 
                  ? 0.0 
                  : (item['total_poin'] is num 
                      ? (item['total_poin'] as num).toDouble()
                      : double.tryParse(item['total_poin'].toString()) ?? 0.0),
            );
          } catch (e) {
            debugPrint('Error parsing statistik item: $e');
            debugPrint('Problematic JSON: $item');
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? 'Unknown',
              totalKegiatan: 0,
              totalPoin: 0.0,
            );
          }
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to load statistik');
      }
    } catch (e) {
      debugPrint('Error in getStatistikAdmin: $e');
      rethrow;
    }
  }

  Future<List<StatistikAdmin>> getStatistikPerTahun(int tahun) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/statistik-admin/tahun/$tahun'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Statistik Per Tahun response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body directly as a list
        final List<dynamic> statistikList = json.decode(response.body);
        
        return statistikList.map((item) {
          try {
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? '',
              totalKegiatan: item['total_kegiatan'] is int 
                  ? item['total_kegiatan'] 
                  : int.tryParse(item['total_kegiatan']?.toString() ?? '0') ?? 0,
              totalPoin: item['total_poin'] == null 
                  ? 0.0 
                  : (item['total_poin'] is num 
                      ? (item['total_poin'] as num).toDouble()
                      : double.tryParse(item['total_poin'].toString()) ?? 0.0),
            );
          } catch (e) {
            debugPrint('Error parsing statistik item: $e');
            debugPrint('Problematic JSON: $item');
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? 'Unknown',
              totalKegiatan: 0,
              totalPoin: 0.0,
            );
          }
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to load statistik');
      }
    } catch (e) {
      debugPrint('Error in getStatistikPerTahun: $e');
      rethrow;
    }
  }

  Future<List<StatistikAdmin>> getStatistikByJurusan(String jurusan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/statistik-admin/jurusan/$jurusan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Statistik Jurusan response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body directly as a list
        final List<dynamic> statistikList = json.decode(response.body);
        
        return statistikList.map((item) {
          try {
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? '',
              totalKegiatan: item['total_kegiatan'] is int 
                  ? item['total_kegiatan'] 
                  : int.tryParse(item['total_kegiatan']?.toString() ?? '0') ?? 0,
              totalPoin: item['total_poin'] == null 
                  ? 0.0 
                  : (item['total_poin'] is num 
                      ? (item['total_poin'] as num).toDouble()
                      : double.tryParse(item['total_poin'].toString()) ?? 0.0),
            );
          } catch (e) {
            debugPrint('Error parsing statistik item: $e');
            debugPrint('Problematic JSON: $item');
            return StatistikAdmin(
              nama: item['nama']?.toString() ?? 'Unknown',
              totalKegiatan: 0,
              totalPoin: 0.0,
            );
          }
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception('Failed to load statistik');
      }
    } catch (e) {
      debugPrint('Error in getStatistikByJurusan: $e');
      rethrow;
    }
  }
}