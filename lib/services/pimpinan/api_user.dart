// lib/services/api_user.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/models/pimpinan/user_model.dart';
import 'package:sdm/services/pimpinan/api_config.dart';

class ApiUser {
  static Future<List<UserModel>> getAllDosen() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          return List<UserModel>.from(
            responseData['data'].map((x) => UserModel.fromJson(x)),
          );
        }
      }
      throw Exception('Failed to load dosen data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<UserModel> getDosenDetail(int id) async {
    try {
      print('Fetching detail for ID: $id'); // Debugging
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan/detail/$id'),
      );

      print('Response status: ${response.statusCode}'); // Debugging
      print('Response body: ${response.body}'); // Debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          return UserModel.fromJson(responseData['data']);
        }
      }
      throw Exception('Failed to load dosen detail');
    } catch (e) {
      print('Error detail: $e'); // Debugging
      throw Exception('Failed to load dosen detail: $e');
    }
  }

  static Future<List<UserModel>> searchDosen(String keyword) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/user-pimpinan/search'),
        body: {'keyword': keyword},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true && responseData['data'] != null) {
          return List<UserModel>.from(
            responseData['data'].map((x) => UserModel.fromJson(x)),
          );
        }
      }
      return [];
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}