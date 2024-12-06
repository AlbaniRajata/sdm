class Agenda {
  int? id;
  int? kegiatanId;
  String? judulAgenda;
  String? deskripsiAgenda;
  DateTime? tanggalAgenda;

  Agenda({
    this.id,
    this.kegiatanId,
    this.judulAgenda,
    this.deskripsiAgenda,
    this.tanggalAgenda,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      kegiatanId: json['kegiatan_id'],
      judulAgenda: json['judul_agenda'],
      deskripsiAgenda: json['deskripsi_agenda'],
      tanggalAgenda: json['tanggal_agenda'] != null ? DateTime.parse(json['tanggal_agenda']) : null,
    );
  }
}