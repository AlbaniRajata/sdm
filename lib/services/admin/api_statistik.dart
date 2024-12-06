import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/statistik_model.dart';
import 'package:sdm/models/admin/statistik_error.dart';
import 'api_config.dart';

class ApiStatistikAdmin {
  final String _baseUrl = '${ApiConfig.baseUrl}/statistik-admin';

  Future<List<StatistikAdmin>> getStatistikAdmin() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return (responseData as List)
            .map((item) => StatistikAdmin.fromJson(item))
            .toList();
      } else {
        throw StatistikAdminError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw StatistikAdminError(message: 'Gagal mengambil data statistik admin: $e');
    }
  }
}