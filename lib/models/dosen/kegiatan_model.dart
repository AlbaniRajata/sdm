import 'package:sdm/models/dosen/anggota_model.dart';
import 'package:sdm/models/dosen/dokumen_model.dart';

class KegiatanModel {
  final int idKegiatan;
  final String namaKegiatan;
  final String? deskripsiKegiatan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String tanggalAcara;
  final String tempatKegiatan;
  final String jenisKegiatan;
  final int? progress;
  final List<AnggotaModel>? anggota;
  final List<DokumenModel>? dokumen;
  final String? jabatanNama;

  KegiatanModel({
    required this.idKegiatan,
    required this.namaKegiatan,
    this.deskripsiKegiatan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.tanggalAcara,
    required this.tempatKegiatan,
    required this.jenisKegiatan,
    this.progress,
    this.anggota,
    this.dokumen,
    this.jabatanNama,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      idKegiatan: json['id_kegiatan'],
      namaKegiatan: json['nama_kegiatan'],
      deskripsiKegiatan: json['deskripsi_kegiatan'],
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
      tanggalAcara: json['tanggal_acara'] ?? '',
      tempatKegiatan: json['tempat_kegiatan'] ?? '',
      jenisKegiatan: json['jenis_kegiatan'] ?? '',
      progress: json['progress'],
      jabatanNama: json['jabatan'],
      anggota: (json['anggota'] as List<dynamic>?)
          ?.map((e) => AnggotaModel.fromJson(e))
          .toList(),
      dokumen: (json['dokumen'] as List<dynamic>?)
          ?.map((e) => DokumenModel.fromJson(e))
          .toList(),
    );
  }
}