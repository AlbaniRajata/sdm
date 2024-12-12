class NotifikasiModel {
  final int idAnggota;
  final String namaKegiatan;
  final String jabatan;
  final String tanggalAcara;
  final DateTime? createdAt;
  bool isRead;

  NotifikasiModel({
    required this.idAnggota,
    required this.namaKegiatan,
    required this.jabatan,
    required this.tanggalAcara,
    this.createdAt,
    this.isRead = false,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      idAnggota: json['id_anggota'],
      namaKegiatan: json['nama_kegiatan'],
      jabatan: json['jabatan'],
      tanggalAcara: json['tanggal_acara'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      isRead: false,
    );
  }
}