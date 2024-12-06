import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/models/admin/kegiatan_model.dart';
import 'package:sdm/models/admin/kegiatan_model_error.dart';
import 'package:sdm/models/admin/kegiatan_model_response.dart';
import 'package:sdm/models/admin/user_model.dart';
import 'api_config.dart';

class ApiKegiatan {
  final String _baseUrl = '${ApiConfig.baseUrl}/kegiatan-admin';

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
        throw KegiatanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal mengambil data kegiatan: $e');
    }
  }

  Future<KegiatanModel> getDetailKegiatan(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return KegiatanModel.fromJson(responseData['data']);
      } else {
        throw KegiatanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal mengambil detail kegiatan: $e');
    }
  }

  Future<KegiatanModel> createKegiatan(KegiatanModel kegiatan) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(kegiatan.toJson()),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return KegiatanModel.fromJson(responseData['data']);
        } else {
          throw responseData['message'] ?? 'Gagal membuat kegiatan';
        }
      } else {
        final errorData = json.decode(response.body);
        throw errorData['message'] ?? 'Gagal membuat kegiatan';
      }
    } catch (e) {
      print('Create kegiatan error: $e');
      throw 'Gagal membuat kegiatan: $e';
    }
  }

  Future<KegiatanModel> updateKegiatan(int id, KegiatanModel kegiatan) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(kegiatan.toJson()),
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return KegiatanModel.fromJson(responseData['data']);
      } else {
        throw KegiatanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal mengupdate kegiatan: $e');
    }
  }

  Future<bool> deleteKegiatan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorData = json.decode(response.body);
        throw KegiatanError(message: errorData['message'] ?? 'Gagal menghapus kegiatan');
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal menghapus kegiatan: $e');
    }
  }

  Future<List<UserModel>> getDosen() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/data/dosen'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return (responseData['data'] as List)
            .map((item) => UserModel.fromJson(item))
            .toList();
      } else {
        throw KegiatanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal mengambil data dosen: $e');
    }
  }

  Future<List<JabatanKegiatan>> getJabatan() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/data/jabatan'),
        headers: {
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return (responseData['data'] as List)
            .map((item) => JabatanKegiatan.fromJson(item))
            .toList();
      } else {
        throw KegiatanError.fromJson(json.decode(response.body));
      }
    } catch (e) {
      throw KegiatanError(message: 'Gagal mengambil data jabatan: $e');
    }
  }
}