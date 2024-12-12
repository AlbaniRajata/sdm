import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sdm/models/dosen/kegiatan_model.dart';
import 'package:sdm/models/dosen/notifikasi_model.dart';
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

  // pic
  Future<List<KegiatanModel>> getKegiatanPICList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pic-kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan PIC List response: ${response.body}');

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
            : json.decode(response.body)['message'] ?? 'Failed to load kegiatan PIC list';
        throw Exception(errorMessage);
      }
    } catch (e) {
      debugPrint('Error in getKegiatanPICList: $e');
      rethrow;
    }
  }

  Future<KegiatanModel> getKegiatanPICDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pic-kegiatan/$idKegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kegiatan PIC Detail response: ${response.body}');

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
            'Failed to load kegiatan PIC detail');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanPICDetail: $e');
      rethrow;
    }
  }

  Future<List<KegiatanModel>> getKegiatanAnggotaList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-kegiatan'),
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

  Future<KegiatanModel> getKegiatanAnggotaDetail(int idKegiatan) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/anggota-kegiatan/$idKegiatan'),
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

  Future<Map<DateTime, String>> getKalenderKegiatanDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-dosen/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kalender Kegiatan response: ${response.body}');

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
              debugPrint('Successfully parsed date: $dateStr to $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing date or event: $e');
              debugPrint('Problematic date string: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Failed to load calendar events'
        );
      }
    } catch (e) {
      debugPrint('Error in getKalenderKegiatan: $e');
      rethrow;
    }
  }

  Future<Map<DateTime, String>> getKalenderKegiatanPIC() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-pic/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kalender Kegiatan response: ${response.body}');

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
              debugPrint('Successfully parsed date: $dateStr to $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing date or event: $e');
              debugPrint('Problematic date string: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Failed to load calendar events'
        );
      }
    } catch (e) {
      debugPrint('Error in getKalenderKegiatan: $e');
      rethrow;
    }
  }

  Future<Map<DateTime, String>> getKalenderKegiatanAnggota() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kalender-anggota/kegiatan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Kalender Kegiatan response: ${response.body}');

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
              debugPrint('Successfully parsed date: $dateStr to $normalizedDate');
            } catch (e) {
              debugPrint('Error parsing date or event: $e');
              debugPrint('Problematic date string: ${item['tanggal_acara']}');
              continue;
            }
          }
          
          return kegiatanMap;
        }
        return {};
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
          json.decode(response.body)['message'] ?? 
          'Failed to load calendar events'
        );
      }
    } catch (e) {
      debugPrint('Error in getKalenderKegiatan: $e');
      rethrow;
    }
  }

  Future<List<NotifikasiModel>> getNotifikasiDosen() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/notifikasi-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Notifikasi Dosen response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> notifikasiList = jsonResponse['data'] ?? [];
          return notifikasiList
              .map((json) => NotifikasiModel.fromJson(json))
              .toList();
        }
        throw Exception(jsonResponse['message'] ?? 'Invalid response format');
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(json.decode(response.body)['message'] ??
            'Failed to load notifikasi');
      }
    } catch (e) {
      debugPrint('Error in getNotifikasiDosen: $e');
      rethrow;
    }
  }

  Future<bool> hasUnreadNotifications() async {
  try {
    final notifications = await getNotifikasiDosen();
    final prefs = await SharedPreferences.getInstance();
    final readNotifications = prefs.getStringList('read_notifications') ?? [];
    
    return notifications.any((notification) => 
      !readNotifications.contains(notification.idAnggota.toString()));
  } catch (e) {
    debugPrint('Error checking unread notifications: $e');
    return false;
  }
}

Future<void> markNotificationAsRead(int notificationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final readNotifications = prefs.getStringList('read_notifications') ?? [];
    if (!readNotifications.contains(notificationId.toString())) {
      readNotifications.add(notificationId.toString());
      await prefs.setStringList('read_notifications', readNotifications);
    }
  } catch (e) {
    debugPrint('Error marking notification as read: $e');
  }
}

Future<bool> isNotificationRead(int notificationId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final readNotifications = prefs.getStringList('read_notifications') ?? [];
    return readNotifications.contains(notificationId.toString());
  } catch (e) {
    debugPrint('Error checking notification status: $e');
    return false;
  }
}
}