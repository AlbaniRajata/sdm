class JabatanKegiatan {
  final int? idJabatanKegiatan;
  String jabatanNama;
  final double poin;
  final String? createdAt;
  final String? updatedAt;

  JabatanKegiatan({
    this.idJabatanKegiatan,
    required this.jabatanNama,
    required this.poin,
    this.createdAt,
    this.updatedAt,
  });

  factory JabatanKegiatan.fromJson(Map<String, dynamic> json) {
    return JabatanKegiatan(
      idJabatanKegiatan: json['id_jabatan_kegiatan'],
      jabatanNama: json['jabatan_nama'] ?? '',
      poin: double.tryParse(json['poin'].toString()) ?? 0.0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jabatan_kegiatan': idJabatanKegiatan,
      'jabatan_nama': jabatanNama,
      'poin': poin,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'JabatanKegiatan{idJabatanKegiatan: $idJabatanKegiatan, jabatanNama: $jabatanNama, poin: $poin}';
  }
}