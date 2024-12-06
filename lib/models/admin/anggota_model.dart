import 'package:sdm/models/admin/jabatan_kegiatan_model.dart';
import 'package:sdm/models/admin/user_model.dart';

class AnggotaModel {
  final int? id;
  final int? idKegiatan;
  final int idUser;
  final int idJabatanKegiatan;
  final UserModel? user;
  final JabatanKegiatan? jabatan;

  AnggotaModel({
    this.id,
    this.idKegiatan,
    required this.idUser,
    required this.idJabatanKegiatan,
    this.user,
    this.jabatan,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_jabatan_kegiatan': idJabatanKegiatan,
    };
  }

  factory AnggotaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaModel(
      id: json['id_anggota'],
      idKegiatan: json['id_kegiatan'],
      idUser: json['id_user'],
      idJabatanKegiatan: json['id_jabatan_kegiatan'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      jabatan: json['jabatan'] != null ? JabatanKegiatan.fromJson(json['jabatan']) : null,
    );
  }
}