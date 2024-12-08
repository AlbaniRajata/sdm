import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/dosen/kegiatan_model.dart';
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
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen'),
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

      debugPrint('Requesting JTI List with token: $token');  // Debug token

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan JTI List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        debugPrint('Decoded response: $jsonResponse'); // Debug response

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) {
              try {
                return KegiatanModel.fromJson(json);
              } catch (e) {
                debugPrint('Error parsing kegiatan: $e');
                debugPrint('Problematic JSON: $json');
                rethrow;
              }
            }).toList();
          } else {
            debugPrint('Data is not a List: ${jsonResponse['data']}');
            return [];
          }
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
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/non-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan Non JTI List response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        debugPrint('Decoded response: $jsonResponse');

      if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) {
              try {
                return KegiatanModel.fromJson(json);
              } catch (e) {
                debugPrint('Error parsing kegiatan: $e');
                debugPrint('Problematic JSON: $json');
                rethrow;
              }
            }).toList();
          } else {
            debugPrint('Data is not a List: ${jsonResponse['data']}');
            return [];
          }
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
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/$idKegiatan'),
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
}