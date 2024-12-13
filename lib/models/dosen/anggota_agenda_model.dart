import 'package:sdm/models/dosen/jabatan_anggota_model.dart';

class AnggotaAgenda {
  final int idAnggota;
  final int idUser;
  final String nama;
  final JabatanAnggota jabatan;

  AnggotaAgenda({
    required this.idAnggota,
    required this.idUser,
    required this.nama,
    required this.jabatan,
  });

  factory AnggotaAgenda.fromJson(Map<String, dynamic> json) => AnggotaAgenda(
    idAnggota: json["id_anggota"] ?? 0,
    idUser: json["id_user"] ?? 0,
    nama: json["nama"] ?? '',
    jabatan: JabatanAnggota.fromJson(json["jabatan"] ?? {}),
  );
}