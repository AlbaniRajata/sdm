import 'jabatan_kegiatan_model.dart';

class JabatanKegiatanResponse {
  final bool status;
  final String message;
  final dynamic data;

  JabatanKegiatanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JabatanKegiatanResponse.fromJson(Map<String, dynamic> json) {
    return JabatanKegiatanResponse(
      status: json['status'] == 'success' ? true : false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  // Helper method untuk mendapatkan single JabatanKegiatan
  JabatanKegiatan? get jabatanKegiatan {
    if (data is Map<String, dynamic>) {
      return JabatanKegiatan.fromJson(data);
    }
    return null;
  }

  // Helper method untuk mendapatkan list JabatanKegiatan
  List<JabatanKegiatan> get jabatanKegiatanList {
    if (data is List) {
      return (data as List)
          .map((item) => JabatanKegiatan.fromJson(item))
          .toList();
    }
    return [];
  }
}