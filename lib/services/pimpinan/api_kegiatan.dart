import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/models/pimpinan/kegiatan_model.dart';
import 'package:sdm/models/pimpinan/kegiatan_model_response.dart';
import 'api_config.dart';

class ApiKegiatan {
  final String _baseUrl = '${ApiConfig.baseUrl}/kegiatan-pimpinan';

  Future<List<KegiatanModel>> getKegiatan() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final kegiatanResponse = KegiatanListResponse.fromJson(responseData);
        
        return kegiatanResponse.data
            .map((item) => KegiatanModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load kegiatan');
      }
    } catch (e) {
      throw Exception('Failed to load kegiatan: $e');
    }
  }

  Future<KegiatanModel> getDetailKegiatan(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return KegiatanModel.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to load detail kegiatan');
      }
    } catch (e) {
      throw Exception('Failed to load detail kegiatan: $e');
    }
  }
}