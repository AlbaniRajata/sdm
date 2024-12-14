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

  // Mendapatkan token
  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Mendapatkan daftar kegiatan
  Future<List<KegiatanModel>> getKegiatanList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList
              .map((json) => KegiatanModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat daftar kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanList: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan JTI
  Future<List<KegiatanModel>> getKegiatanJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan JTI: ${response.body}');

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
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanJTIList: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan Non JTI
  Future<List<KegiatanModel>> getKegiatanNonJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/non-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan Non JTI: ${response.body}');

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
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan non-JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanNonJTIList: $e');
      rethrow;
    }
  }

  // Mendapatkan detail kegiatan
  Future<KegiatanModel> getKegiatanDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response detail kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat detail kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanDetail: $e');
      rethrow;
    }
  }

  // Menyetujui kegiatan
  Future<bool> approveKegiatan(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/$idKegiatan/approve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response approve kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == true;
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal menyetujui kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam approveKegiatan: $e');
      rethrow;
    }
  }

  // Menolak kegiatan
  Future<bool> rejectKegiatan(int idKegiatan, String reason) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
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

      debugPrint('Response reject kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == true;
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal menolak kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam rejectKegiatan: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan yang pending
  Future<List<KegiatanModel>> getPendingKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-pimpinan/pending'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan pending: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList
              .map((json) => KegiatanModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat daftar kegiatan pending');
      }
    } catch (e) {
      debugPrint('Error dalam getPendingKegiatan: $e');
      rethrow;
    }
  }

  // Mendapatkan kalender kegiatan
  Future<Map<DateTime, String>> getKalenderKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-pimpinan/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response kalender kegiatan: ${response.body}');

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
              debugPrint('Berhasil parsing tanggal: $dateStr ke $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing tanggal atau kegiatan: $e');
              debugPrint('String tanggal bermasalah: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Gagal memuat kalender kegiatan'
        );
      }
    } catch (e) {
      debugPrint('Error dalam getKalenderKegiatan: $e');
      rethrow;
    }
  }
}