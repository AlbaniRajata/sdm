import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/models/pimpinan/statistik_model.dart';
import 'package:sdm/models/pimpinan/statistik_error.dart';
import 'api_config.dart';

class ApiStatistikPimpinan {
  final String _baseUrl = '${ApiConfig.baseUrl}/statistik-pimpinan';

  Future<List<StatistikPimpinan>> getStatistikPimpinan() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return (responseData as List)
            .map((item) => StatistikPimpinan.fromJson(item))
            .toList();
      } else {
        throw StatistikPimpinanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw StatistikPimpinanError(message: 'Gagal mengambil data statistik pimpinan: $e');
    }
  }
}