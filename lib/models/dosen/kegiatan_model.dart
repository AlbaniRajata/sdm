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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_kegiatan': idKegiatan,
      'nama_kegiatan': namaKegiatan,
      'deskripsi_kegiatan': deskripsiKegiatan,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'tanggal_acara': tanggalAcara,
      'tempat_kegiatan': tempatKegiatan,
      'jenis_kegiatan': jenisKegiatan,
      'progress': progress,
    };
  }
}