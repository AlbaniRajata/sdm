import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/dosen/agenda_model.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAgenda {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiAgenda({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<List<AgendaModel>> getKegiatanPIC() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/agenda-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Agenda PIC response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          final List<dynamic> agendaList = jsonResponse['data'];
          return agendaList.map((json) => AgendaModel.fromJson(json)).toList();
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat daftar agenda');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanPIC: $e');
      rethrow;
    }
  }

  Future<AgendaModel> getDetailKegiatan(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/agenda-kegiatan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Agenda Detail response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return AgendaModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat detail agenda');
      }
    } catch (e) {
      debugPrint('Error in getDetailKegiatan: $e');
      rethrow;
    }
  }

  Future<List<KegiatanModel>> getKegiatanAgendaList() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak tersedia. Silakan login kembali.');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-agenda'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> data = responseData['data'];
          return data.map((e) => KegiatanModel.fromJson(e)).toList();
        }
        throw Exception(responseData['message']);
      }
      throw Exception('Gagal memuat daftar kegiatan agenda');
    } catch (e) {
      rethrow;
    }
  }

  Future<AgendaModel> getDetailAgenda(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-agenda/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Agenda Detail response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return AgendaModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format respons tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Gagal memuat detail agenda');
      }
    } catch (e) {
      debugPrint('Error in getDetailAgenda: $e');
      rethrow;
    }
  }
}