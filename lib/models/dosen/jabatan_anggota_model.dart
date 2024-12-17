class JabatanAnggota {
  final int idJabatanKegiatan;
  final String jabatanNama;
  final String poin;

  JabatanAnggota({
    required this.idJabatanKegiatan,
    required this.jabatanNama,
    required this.poin,
  });

  factory JabatanAnggota.fromJson(Map<String, dynamic> json) {
    return JabatanAnggota(
      idJabatanKegiatan: json['id_jabatan_kegiatan'] ?? 0,
      jabatanNama: json['jabatan_nama'] ?? '',
      poin: json['poin']?.toString() ?? '0',
    );
  }
}