import 'package:intl/intl.dart';
import 'package:sdm/models/pimpinan/anggota_model.dart';

class KegiatanModel {
  final int? idKegiatan;
  String namaKegiatan;
  String deskripsiKegiatan;
  DateTime tanggalMulai;
  DateTime tanggalSelesai;
  DateTime tanggalAcara;
  String tempatKegiatan;
  String jenisKegiatan;
  int progress;
  List<AnggotaModel> anggota;

  KegiatanModel({
    this.idKegiatan,
    required this.namaKegiatan,
    required this.deskripsiKegiatan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.tanggalAcara,
    required this.tempatKegiatan,
    required this.jenisKegiatan,
    required this.progress,
    required this.anggota,
  });

  Map<String, dynamic> toJson() {
    final DateFormat apiFormat = DateFormat('yyyy-MM-dd');
    return {
      'id_kegiatan': idKegiatan,
      'nama_kegiatan': namaKegiatan,
      'deskripsi_kegiatan': deskripsiKegiatan,
      'tanggal_mulai': apiFormat.format(tanggalMulai),
      'tanggal_selesai': apiFormat.format(tanggalSelesai),
      'tanggal_acara': apiFormat.format(tanggalAcara),
      'tempat_kegiatan': tempatKegiatan,
      'jenis_kegiatan': jenisKegiatan,
      'progress': progress,
      'anggota': anggota.map((e) => e.toJson()).toList(),
    };
  }

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      idKegiatan: json['id_kegiatan'],
      namaKegiatan: json['nama_kegiatan'] ?? '',
      deskripsiKegiatan: json['deskripsi_kegiatan'] ?? '',
      tanggalMulai: _parseDate(json['tanggal_mulai']),
      tanggalSelesai: _parseDate(json['tanggal_selesai']),
      tanggalAcara: _parseDate(json['tanggal_acara']),
      tempatKegiatan: json['tempat_kegiatan'] ?? '',
      jenisKegiatan: json['jenis_kegiatan'] ?? '',
      progress: json['progress'] ?? 0,
      anggota: (json['anggota'] as List?)
          ?.map((e) => AnggotaModel.fromJson(e))
          .toList() ?? [],
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    
    if (date is String) {
      try {
        return DateFormat('dd-MM-yyyy').parseStrict(date);
      } catch (e) {
        print('Error parsing date: $date');
        return DateTime.now();
      }
    }
    
    return DateTime.now();
  }
}