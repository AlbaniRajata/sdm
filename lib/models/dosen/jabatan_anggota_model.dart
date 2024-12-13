class JabatanAnggota {
  final int idJabatanKegiatan;
  final String namaJabatan;

  JabatanAnggota({
    required this.idJabatanKegiatan,
    required this.namaJabatan,
  });

  factory JabatanAnggota.fromJson(Map<String, dynamic> json) => JabatanAnggota(
    idJabatanKegiatan: json["id_jabatan_kegiatan"] ?? 0,
    namaJabatan: json["nama_jabatan"] ?? '',
  );
}