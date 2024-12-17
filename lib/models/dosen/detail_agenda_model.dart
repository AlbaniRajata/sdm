import 'package:sdm/models/dosen/anggota_agenda_model.dart';
import 'package:sdm/models/dosen/jabatan_anggota_model.dart';

class DetailAgendaModel {
  final int idKegiatan;
  final String namaKegiatan;
  final String? deskripsiKegiatan;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String tanggalAcara;
  final String? tempatKegiatan;
  final String jenisKegiatan;
  final int progress;
  final List<DetailAnggotaModel> anggota;
  final List<DetailAgendaItemModel> agenda;

  DetailAgendaModel({
    required this.idKegiatan,
    required this.namaKegiatan,
    this.deskripsiKegiatan,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.tanggalAcara,
    this.tempatKegiatan,
    required this.jenisKegiatan,
    required this.progress,
    required this.anggota,
    required this.agenda,
  });

  factory DetailAgendaModel.fromJson(Map<String, dynamic> json) {
    return DetailAgendaModel(
      idKegiatan: json['id_kegiatan'] ?? 0,
      namaKegiatan: json['nama_kegiatan'] ?? '',
      deskripsiKegiatan: json['deskripsi_kegiatan'],
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
      tanggalAcara: json['tanggal_acara'] ?? '',
      tempatKegiatan: json['tempat_kegiatan'],
      jenisKegiatan: json['jenis_kegiatan'] ?? '',
      progress: json['progress'] ?? 0,
      anggota: (json['anggota'] as List<dynamic>?)
              ?.map((x) => DetailAnggotaModel.fromJson(x))
              .toList() ??
          [],
      agenda: (json['agenda'] as List<dynamic>?)
              ?.map((x) => DetailAgendaItemModel.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class DetailAnggotaModel {
  final int idAnggota;
  final int idUser;
  final UserModel user;
  final JabatanAnggota jabatan;

  DetailAnggotaModel({
    required this.idAnggota,
    required this.idUser,
    required this.user,
    required this.jabatan,
  });

  factory DetailAnggotaModel.fromJson(Map<String, dynamic> json) {
    return DetailAnggotaModel(
      idAnggota: json['id_anggota'] ?? 0,
      idUser: json['id_user'] ?? 0,
      user: UserModel.fromJson(json['user'] ?? {}),
      jabatan: JabatanAnggota.fromJson(json['jabatan'] ?? {}),
    );
  }
}

class DetailAgendaItemModel {
  final int idAgenda;
  final int idKegiatan;
  final List<AnggotaAgenda> agendaAnggota;

  DetailAgendaItemModel({
    required this.idAgenda,
    required this.idKegiatan,
    required this.agendaAnggota,
  });

  factory DetailAgendaItemModel.fromJson(Map<String, dynamic> json) {
    return DetailAgendaItemModel(
      idAgenda: json['id_agenda'] ?? 0,
      idKegiatan: json['id_kegiatan'] ?? 0,
      agendaAnggota: (json['agenda_anggota'] as List<dynamic>?)
              ?.map((x) => AnggotaAgenda.fromJson(x))
              .toList() ??
          [],
    );
  }
}

class UserModel {
  final int idUser;
  final String nama;

  UserModel({
    required this.idUser,
    required this.nama,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? '',
    );
  }
}