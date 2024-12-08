import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-admin'),
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to load kegiatan list');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanList: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> getKegiatanDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token not available. Please login again.');
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to load kegiatan detail');
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
        throw KegiatanError(message: 'Token not available. Please login again.');
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

      debugPrint('Create Kegiatan response: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw KegiatanError(message: jsonResponse['message'] ?? 'Failed to create kegiatan');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to create kegiatan');
      }
    } catch (e) {
      debugPrint('Error in createKegiatan: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> updateKegiatan(int id, KegiatanModel kegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token not available. Please login again.');
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Failed to update kegiatan');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to update kegiatan');
      }
    } catch (e) {
      debugPrint('Error in updateKegiatan: $e');
      rethrow;
    }
  }

  Future<bool> deleteKegiatan(int id) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token not available. Please login again.');
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
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to delete kegiatan');
      }
    } catch (e) {
      debugPrint('Error in deleteKegiatan: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token not available. Please login again.');
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to load dosen list');
      }
    } catch (e) {
      debugPrint('Error in getDosen: $e');
      rethrow;
    }
  }

  Future<List<JabatanKegiatan>> getJabatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw KegiatanError(message: 'Token not available. Please login again.');
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
        throw KegiatanError(message: jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw KegiatanError(message: 'Session expired. Please login again.');
      } else {
        throw KegiatanError(
            message: json.decode(response.body)['message'] ?? 
                'Failed to load jabatan list');
      }
    } catch (e) {
      debugPrint('Error in getJabatan: $e');
      rethrow;
    }
  }
}