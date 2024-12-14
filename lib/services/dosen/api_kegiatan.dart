import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/models/dosen/notifikasi_model.dart';
import 'package:sdm/services/api_config.dart';
import 'package:sdm/widget/custom_top_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiKegiatan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiKegiatan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  // Mendapatkan token
  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Mendapatkan daftar kegiatan
  Future<List<KegiatanModel>> getKegiatanList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList.map((json) => KegiatanModel.fromJson(json)).toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanList: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan JTI
  Future<List<KegiatanModel>> getKegiatanJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan JTI: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) {
              try {
                return KegiatanModel.fromJson(json);
              } catch (e) {
                debugPrint('Error parsing kegiatan: $e');
                debugPrint('JSON bermasalah: $json');
                rethrow;
              }
            }).toList();
          } else {
            debugPrint('Data bukan List: ${jsonResponse['data']}');
            return [];
          }
        } else if (jsonResponse['data'] == null) {
          return [];
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanJTIList: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan Non JTI
  Future<List<KegiatanModel>> getKegiatanNonJTIList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/non-jti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan Non JTI: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) {
              try {
                return KegiatanModel.fromJson(json);
              } catch (e) {
                debugPrint('Error parsing kegiatan: $e');
                debugPrint('JSON bermasalah: $json');
                rethrow;
              }
            }).toList();
          } else {
            debugPrint('Data bukan List: ${jsonResponse['data']}');
            return [];
          }
        } else if (jsonResponse['data'] == null) {
          return [];
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404 
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan Non JTI';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanNonJTIList: $e');
      rethrow;
    }
  }

  // Mendapatkan detail kegiatan
  Future<KegiatanModel> getKegiatanDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/kegiatan-dosen/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response detail kegiatan: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat detail kegiatan');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanDetail: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan PIC
  Future<List<KegiatanModel>> getKegiatanPICList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pic-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan PIC: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          if (jsonResponse['data'] is List) {
            final List<dynamic> kegiatanList = jsonResponse['data'];
            return kegiatanList.map((json) {
              try {
                return KegiatanModel.fromJson(json);
              } catch (e) {
                debugPrint('Error parsing kegiatan: $e');
                debugPrint('JSON bermasalah: $json');
                rethrow;
              }
            }).toList();
          } else {
            debugPrint('Data bukan List: ${jsonResponse['data']}');
            return [];
          }
        } else if (jsonResponse['data'] == null) {
          return [];
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        final errorMessage = response.statusCode == 404
            ? 'Data tidak ditemukan'
            : json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan PIC';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanPICList: $e');
      rethrow;
    }
  }

  // Mendapatkan detail kegiatan PIC
  Future<KegiatanModel> getKegiatanPICDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pic-kegiatan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response detail kegiatan PIC: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat detail kegiatan PIC');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanPICDetail: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar kegiatan anggota
  Future<List<KegiatanModel>> getKegiatanAnggotaList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response daftar kegiatan anggota: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          final List<dynamic> kegiatanList = jsonResponse['data'] ?? [];
          return kegiatanList.map((json) => KegiatanModel.fromJson(json)).toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat daftar kegiatan anggota');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanAnggotaList: $e');
      rethrow;
    }
  }

  // Mendapatkan detail kegiatan anggota
  Future<KegiatanModel> getKegiatanAnggotaDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-kegiatan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response detail kegiatan anggota: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true) {
          return KegiatanModel.fromJson(jsonResponse['data']);
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Gagal memuat detail kegiatan anggota');
      }
    } catch (e) {
      debugPrint('Error dalam getKegiatanAnggotaDetail: $e');
      rethrow;
    }
  }

  // Mendapatkan kalender kegiatan dosen
  Future<Map<DateTime, String>> getKalenderKegiatanDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-dosen/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response kalender kegiatan dosen: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final Map<DateTime, String> kegiatanMap = {};
          
          for (var item in jsonResponse['data']) {
            try {
              final String dateStr = item['tanggal_acara'].toString();
              final DateTime date = DateFormat('dd-MM-yyyy').parse(dateStr);
              
              final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
              final String namaKegiatan = item['nama_kegiatan'].toString();
              
              kegiatanMap[normalizedDate] = namaKegiatan;
              debugPrint('Berhasil parsing tanggal: $dateStr ke $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing tanggal atau kegiatan: $e');
              debugPrint('String tanggal bermasalah: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Gagal memuat kalender kegiatan'
        );
      }
    } catch (e) {
      debugPrint('Error dalam getKalenderKegiatanDosen: $e');
      rethrow;
    }
  }

  // Mendapatkan kalender kegiatan PIC
  Future<Map<DateTime, String>> getKalenderKegiatanPIC() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-pic/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response kalender kegiatan PIC: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final Map<DateTime, String> kegiatanMap = {};
          
          for (var item in jsonResponse['data']) {
            try {
              final String dateStr = item['tanggal_acara'].toString();
              final DateTime date = DateFormat('dd-MM-yyyy').parse(dateStr);
              
              final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
              final String namaKegiatan = item['nama_kegiatan'].toString();
              
              kegiatanMap[normalizedDate] = namaKegiatan;
              debugPrint('Berhasil parsing tanggal: $dateStr ke $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing tanggal atau kegiatan: $e');
              debugPrint('String tanggal bermasalah: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Gagal memuat kalender kegiatan PIC'
        );
      }
    } catch (e) {
      debugPrint('Error dalam getKalenderKegiatanPIC: $e');
      rethrow;
    }
  }

  // Mendapatkan kalender kegiatan anggota
  Future<Map<DateTime, String>> getKalenderKegiatanAnggota() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-anggota/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response kalender kegiatan anggota: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final Map<DateTime, String> kegiatanMap = {};
          
          for (var item in jsonResponse['data']) {
            try {
              final String dateStr = item['tanggal_acara'].toString();
              final DateTime date = DateFormat('dd-MM-yyyy').parse(dateStr);
              
              final DateTime normalizedDate = DateTime(date.year, date.month, date.day);
              final String namaKegiatan = item['nama_kegiatan'].toString();
              
              kegiatanMap[normalizedDate] = namaKegiatan;
              debugPrint('Berhasil parsing tanggal: $dateStr ke $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing tanggal atau kegiatan: $e');
              debugPrint('String tanggal bermasalah: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Gagal memuat kalender kegiatan anggota'
        );
      }
    } catch (e) {
      debugPrint('Error dalam getKalenderKegiatanAnggota: $e');
      rethrow;
    }
  }

  // Mendapatkan notifikasi dosen
  Future<List<NotifikasiModel>> getNotifikasiDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/notifikasi-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response notifikasi dosen: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> notifikasiList = jsonResponse['data'] ?? [];
          return notifikasiList
              .map((json) => NotifikasiModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Format response tidak valid');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login kembali.');
      } else {
        throw Exception(json.decode(response.body)['message'] ??
            'Gagal memuat notifikasi');
      }
    } catch (e) {
      debugPrint('Error dalam getNotifikasiDosen: $e');
      rethrow;
    }
  }

  // Mengecek notifikasi yang belum dibaca
  Future<bool> hasUnreadNotifications() async {
    try {
      final notifications = await getNotifikasiDosen();
      final prefs = await SharedPreferences.getInstance();
      final readNotifications = prefs.getStringList('read_notifications') ?? [];
      
      return notifications.any((notification) => 
        !readNotifications.contains(notification.idAnggota.toString()));
    } catch (e) {
      debugPrint('Error mengecek notifikasi yang belum dibaca: $e');
      return false;
    }
  }

  // Menandai notifikasi sudah dibaca
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readNotifications = prefs.getStringList('read_notifications') ?? [];
      if (!readNotifications.contains(notificationId.toString())) {
        readNotifications.add(notificationId.toString());
        await prefs.setStringList('read_notifications', readNotifications);
      }
    } catch (e) {
      debugPrint('Error menandai notifikasi sudah dibaca: $e');
    }
  }

  // Mengecek status notifikasi
  Future<bool> isNotificationRead(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final readNotifications = prefs.getStringList('read_notifications') ?? [];
      return readNotifications.contains(notificationId.toString());
    } catch (e) {
      debugPrint('Error mengecek status notifikasi: $e');
      return false;
    }
  }

  // Download dokumen
  Future<void> downloadDokumen(int idDokumen, String namaDokumen, BuildContext context) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia');
      }

      CustomTopSnackBar.show(context, 'Mengunduh $namaDokumen...', isError: false);

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/download-dokumen/$idDokumen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$namaDokumen';
        
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        if (context.mounted) {
          CustomTopSnackBar.show(context, '$namaDokumen berhasil diunduh', isError: false);
        }
        
        await OpenFile.open(filePath);
      } else {
        throw Exception('Gagal mengunduh file');
      }
    } catch (e) {
      if (context.mounted) {
        CustomTopSnackBar.show(context, 'Error: ${e.toString()}');
      }
      rethrow;
    }
  }
}