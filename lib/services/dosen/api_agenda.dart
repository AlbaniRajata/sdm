import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sdm/models/dosen/agenda_model.dart';
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
        throw Exception('Token not available. Please login again.');
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
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load agenda list');
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
        throw Exception('Token not available. Please login again.');
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
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load agenda detail');
      }
    } catch (e) {
      debugPrint('Error in getDetailKegiatan: $e');
      rethrow;
    }
  }

  Future<List<AgendaModel>> getUpcomingKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/agenda-kegiatan/upcoming'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Upcoming Agenda response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> agendaList = jsonResponse['data'];
            return agendaList.map((json) => AgendaModel.fromJson(json)).toList();
          }
          return [];
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 
            'Failed to load upcoming agenda');
      }
    } catch (e) {
      debugPrint('Error in getUpcomingKegiatan: $e');
      rethrow;
    }
  }
}