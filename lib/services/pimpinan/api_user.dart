import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiUser {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiUser({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<UserModel>> getAllDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Get All Dosen response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          final List<dynamic> dosenList = jsonResponse['data'];
          return dosenList.map((item) {
            try {
              item['username'] = item['username'] ?? '';
              item['nama'] = item['nama'] ?? '';
              item['email'] = item['email'] ?? '';
              item['NIP'] = item['NIP'] ?? '';
              item['level'] = item['level'] ?? '';
              item['tanggal_lahir'] = item['tanggal_lahir'] ?? DateTime.now().toIso8601String();
              
              return UserModel.fromJson(item);
            } catch (e) {
              debugPrint('Error parsing user data: $e');
              debugPrint('JSON bermasalah: $item');

              return UserModel(
                idUser: item['id_user'] ?? 0,
                username: item['username'] ?? '',
                nama: item['nama'] ?? '',
                email: item['email'] ?? '',
                nip: item['NIP'] ?? '',
                level: item['level'] ?? '',
                tanggalLahir: DateTime.now(),
                totalKegiatan: 0,
                totalPoin: 0.0,
                jabatan: [],
                kegiatan: [],
              );
            }
          }).toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat daftar dosen');
      }
    } catch (e) {
      debugPrint('Error in getAllDosen: $e');
      rethrow;
    }
  }

  Future<UserModel> getDosenDetail(int id) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan/detail/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dosen Detail response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          try {
            final data = jsonResponse['data'];
            
            final processedData = {
              'id_user': data['id_user'] ?? 0,
              'username': data['username']?.toString() ?? '',
              'nama': data['nama']?.toString() ?? '',
              'email': data['email']?.toString() ?? '',
              'NIP': data['NIP']?.toString().trim() ?? '',
              'level': data['level']?.toString() ?? '',
              'tanggal_lahir': data['tanggal_lahir'] ?? DateTime.now().toIso8601String(),
              'total_kegiatan': data['total_kegiatan'] ?? 0,
              'total_poin': data['total_poin'] ?? 0.0,
              'jabatan': (data['jabatan'] is List) 
                  ? List<String>.from(data['jabatan'].map((e) => e.toString()))
                  : <String>[],
              'kegiatan': (data['kegiatan'] is List)
                  ? List<String>.from(data['kegiatan'].map((e) => e.toString()))
                  : <String>[],
            };

            return UserModel(
              idUser: processedData['id_user'],
              username: processedData['username'],
              nama: processedData['nama'],
              email: processedData['email'],
              nip: processedData['NIP'],
              level: processedData['level'],
              tanggalLahir: DateTime.parse(processedData['tanggal_lahir']),
              totalKegiatan: processedData['total_kegiatan'] is int 
                  ? processedData['total_kegiatan'] 
                  : int.tryParse(processedData['total_kegiatan'].toString()) ?? 0,
              totalPoin: processedData['total_poin'] is double 
                  ? processedData['total_poin'] 
                  : double.tryParse(processedData['total_poin'].toString()) ?? 0.0,
              jabatan: processedData['jabatan'],
              kegiatan: processedData['kegiatan'],
            );
          } catch (e) {
            debugPrint('Error parsing user detail: $e');
            debugPrint('JSON bermasalah: ${jsonResponse['data']}');
            
            return UserModel(
              idUser: jsonResponse['data']['id_user'] ?? 0,
              username: jsonResponse['data']['username']?.toString() ?? '',
              nama: jsonResponse['data']['nama']?.toString() ?? '',
              email: jsonResponse['data']['email']?.toString() ?? '',
              nip: jsonResponse['data']['NIP']?.toString().trim() ?? '',
              level: jsonResponse['data']['level']?.toString() ?? '',
              tanggalLahir: DateTime.now(),
              totalKegiatan: 0,
              totalPoin: 0.0,
              jabatan: [],
              kegiatan: [],
            );
          }
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Dosen tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat detail dosen';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getDosenDetail: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> searchDosen(String keyword) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'keyword': keyword}),
      );

      debugPrint('Search Dosen response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> dosenList = jsonResponse['data'];
          return dosenList.map((item) {
            try {
              return UserModel.fromJson(item);
            } catch (e) {
              debugPrint('Error parsing search result: $e');
              debugPrint('JSON bermasalah: $item');
              rethrow;
            }
          }).toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Tidak ada hasil yang ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal mencari dosen';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in searchDosen: $e');
      rethrow;
    }
  }
}