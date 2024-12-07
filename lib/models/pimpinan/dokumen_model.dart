class Dokumen {
  int? id;
  int? kegiatanId;
  String? namaDokumen;
  String? deskripsiDokumen;
  String? urlDokumen;

  Dokumen({
    this.id,
    this.kegiatanId,
    this.namaDokumen,
    this.deskripsiDokumen,
    this.urlDokumen,
  });

  factory Dokumen.fromJson(Map<String, dynamic> json) {
    return Dokumen(
      id: json['id'],
      kegiatanId: json['kegiatan_id'],
      namaDokumen: json['nama_dokumen'],
      deskripsiDokumen: json['deskripsi_dokumen'],
      urlDokumen: json['url_dokumen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kegiatan_id': kegiatanId,
      'nama_dokumen': namaDokumen,
      'deskripsi_dokumen': deskripsiDokumen,
      'url_dokumen': urlDokumen,
    };
  }
}