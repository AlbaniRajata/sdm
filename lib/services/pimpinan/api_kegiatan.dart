import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sdm/models/pimpinan/kegiatan_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKegiatan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiKegiatan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<KegiatanModel>> getKegiatanList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList
              .map((json) => KegiatanModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load kegiatan list');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanList: $e');
      rethrow;
    }
  }

  Future<List<KegiatanModel>> getKegiatanJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan JTI List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) => KegiatanModel.fromJson(json)).toList();
          }
          return [];
        } else if (jsonResponse['data'] == null) {
          return [];
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data not found'
            : json.decode(response.body)['message'] ?? 'Failed to load kegiatan JTI list';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getKegiatanJTIList: $e');
      rethrow;
    }
  }

  Future<List<KegiatanModel>> getKegiatanNonJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/non-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan Non JTI List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) => KegiatanModel.fromJson(json)).toList();
          }
          return [];
        } else if (jsonResponse['data'] == null) {
          return [];
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data not found'
            : json.decode(response.body)['message'] ?? 'Failed to load kegiatan non-JTI list';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getKegiatanNonJTIList: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> getKegiatanDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan Detail response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load kegiatan detail');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanDetail: $e');
      rethrow;
    }
  }

  Future<bool> approveKegiatan(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/$idKegiatan/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Approve Kegiatan response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == true;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to approve kegiatan');
      }
    } catch (e) {
      debugPrint('Error in approveKegiatan: $e');
      rethrow;
    }
  }

  Future<bool> rejectKegiatan(int idKegiatan, String reason) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/$idKegiatan/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'reason': reason}),
      );

      debugPrint('Reject Kegiatan response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == true;
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to reject kegiatan');
      }
    } catch (e) {
      debugPrint('Error in rejectKegiatan: $e');
      rethrow;
    }
  }

  Future<List<KegiatanModel>> getPendingKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Pending Kegiatan List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList
              .map((json) => KegiatanModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load pending kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getPendingKegiatan: $e');
      rethrow;
    }
  }

  Future<Map<DateTime, String>> getKalenderKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-pimpinan/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kalender Kegiatan response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final Map<DateTime, String> kegiatanMap = {};
          
          for (var item in jsonResponse['data']) {
            try {
              final String dateStr = item['tanggal_acara'].toString();
              final DateTime date = DateFormat('dd-MM-yyyy').parse(dateStr);
              
              final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
              final String namaKegiatan = item['nama_kegiatan'].toString();
              
              kegiatanMap[normalizedDate] = namaKegiatan;
              debugPrint('Successfully parsed date: $dateStr to $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing date or event: $e');
              debugPrint('Problematic date string: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Failed to load calendar events'
        );
      }
    } catch (e) {
      debugPrint('Error in getKalenderKegiatan: $e');
      rethrow;
    }
  }
}