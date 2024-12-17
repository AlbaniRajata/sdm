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

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    return AgendaModel(
      idKegiatan: json["id_kegiatan"]?.toInt() ?? 0,
      namaKegiatan: json["nama_kegiatan"]?.toString() ?? '',
      tempatKegiatan: json["tempat_kegiatan"]?.toString(),
      deskripsiKegiatan: json["deskripsi_kegiatan"]?.toString(),
      tanggalMulai: json["tanggal_mulai"]?.toString() ?? '',
      tanggalSelesai: json["tanggal_selesai"]?.toString() ?? '',
      tanggalAcara: json["tanggal_acara"]?.toString() ?? '',
      anggota: json["anggota"] != null 
          ? List<AnggotaAgenda>.from(json["anggota"].map((x) => AnggotaAgenda.fromJson(x)))
          : [],
      agenda: json["agenda"] != null
          ? List<AgendaItem>.from(json["agenda"].map((x) => AgendaItem.fromJson(x)))
          : [],
    );
  }
}
