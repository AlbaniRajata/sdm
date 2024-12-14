import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/pimpinan/statistik_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiStatistikPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiStatistikPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<StatistikPimpinan>> getStatistikPimpinan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/statistik-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Statistik Pimpinan response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> statistikList = json.decode(response.body);
        
        return statistikList.map((item) {
          try {
            return StatistikPimpinan(
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
            debugPrint('JSON bermasalah: $item');
            return StatistikPimpinan(
              nama: item['nama']?.toString() ?? '-',
              totalKegiatan: 0,
              totalPoin: 0.0,
            );
          }
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception('Gagal memuat statistik');
      }
    } catch (e) {
      debugPrint('Error in getStatistikPimpinan: $e');
      rethrow;
    }
  }

  Future<List<StatistikPimpinan>> getStatistikPerTahun(int tahun) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/statistik-pimpinan/tahun/$tahun'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Statistik Per Tahun response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> statistikList = json.decode(response.body);
        
        return statistikList.map((item) {
          try {
            return StatistikPimpinan(
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
            debugPrint('JSON bermasalah: $item');
            return StatistikPimpinan(
              nama: item['nama']?.toString() ?? 'Unknown',
              totalKegiatan: 0,
              totalPoin: 0.0,
            );
          }
        }).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception('Gagal memuat statistik');
      }
    } catch (e) {
      debugPrint('Error in getStatistikPerTahun: $e');
      rethrow;
    }
  }
}