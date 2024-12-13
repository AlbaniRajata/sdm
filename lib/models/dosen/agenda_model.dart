import 'package:sdm/models/dosen/anggota_agenda_model.dart';

class AgendaModel {
  final int idKegiatan;
  final String namaKegiatan;
  final String? tempatKegiatan;
  final String? deskripsiKegiatan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String tanggalAcara;
  final List<AnggotaAgenda> anggota;
  final List<AgendaItem> agenda;

  AgendaModel({
    required this.idKegiatan,
    required this.namaKegiatan,
    this.tempatKegiatan,
    this.deskripsiKegiatan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.tanggalAcara,
    required this.anggota,
    required this.agenda,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) => AgendaModel(
    idKegiatan: json["id_kegiatan"] ?? 0,
    namaKegiatan: json["nama_kegiatan"] ?? '',
    tempatKegiatan: json["tempat_kegiatan"],
    deskripsiKegiatan: json["deskripsi_kegiatan"],
    tanggalMulai: json["tanggal_mulai"] ?? '',
    tanggalSelesai: json["tanggal_selesai"] ?? '',
    tanggalAcara: json["tanggal_acara"] ?? '',
    anggota: List<AnggotaAgenda>.from(
      (json["anggota"] ?? []).map((x) => AnggotaAgenda.fromJson(x))
    ),
    agenda: List<AgendaItem>.from(
      (json["agenda"] ?? []).map((x) => AgendaItem.fromJson(x))
    ),
  );
}

class AgendaItem {
  final int idAgendaAnggota;
  final int idAgenda;
  final String namaAgenda;

  AgendaItem({
    required this.idAgendaAnggota,
    required this.idAgenda,
    required this.namaAgenda,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) => AgendaItem(
    idAgendaAnggota: json["id_agenda_anggota"] ?? 0,
    idAgenda: json["id_agenda"] ?? 0,
    namaAgenda: json["nama_agenda"] ?? '',
  );
}