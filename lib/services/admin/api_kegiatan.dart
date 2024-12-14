import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sdm/models/admin/kegiatan_model.dart';
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'package:sdm/models/admin/kegiatan_model_error.dart';
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
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan List respon: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList
            .map((json) => KegiatanModel.fromJson(json))
            .toList();
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan');
      }
    } catch (e) {
      debugPrint('Error di getKegiatanList: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> getKegiatanDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin/$idKegiatan'),
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Gagal memuat detail kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanDetail: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> createKegiatan(KegiatanModel kegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(kegiatan.toJson()),
      );

      debugPrint('Membuat Kegiatan respon: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Gagal membuat kegiatan');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal membuat kegiatan');
      }
    } catch (e) {
      debugPrint('Error di createKegiatan: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> updateKegiatan(int id, KegiatanModel kegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(kegiatan.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Gagal memperbarui kegiatan');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal memperbarui kegiatan');
      }
    } catch (e) {
      debugPrint('Error di updateKegiatan: $e');
      rethrow;
    }
  }

  Future<bool> deleteKegiatan(int id) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['status'] == true;
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal menghapus kegiatan');
      }
    } catch (e) {
      debugPrint('Error di deleteKegiatan: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin/data/dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> dosenList = jsonResponse['data'] ?? [];
          return dosenList.map((json) => UserModel.fromJson(json)).toList();
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal memuat daftar dosen');
      }
    } catch (e) {
      debugPrint('Error di getDosen: $e');
      rethrow;
    }
  }

  Future<List<JabatanKegiatan>> getJabatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin/data/jabatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> jabatanList = jsonResponse['data'] ?? [];
          return jabatanList.map((json) => JabatanKegiatan.fromJson(json)).toList();
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw KegiatanError(message: json.decode(response.body)['message'] ?? 'Gagal memuat daftar jabatan');
      }
    } catch (e) {
      debugPrint('Error di getJabatan: $e');
      rethrow;
    }
  }

  Future<Map<DateTime, String>> getKalenderKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-admin/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kalender Kegiatan respon: ${response.body}');

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
              debugPrint('Berhasil menguraikan tanggal: $dateStr ke $normalizedDate');
            } catch (e) {
              debugPrint('Gagal menguraikan tanggal atau acara: $e');
              debugPrint('Problematic date string: ${item['tanggal_acara']}');
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
          'Gagal memuat acara kalender'
        );
      }
    } catch (e) {
      debugPrint('Error di getKalenderKegiatan: $e');
      rethrow;
    }
  }
}