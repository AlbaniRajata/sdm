// lib/models/user_model.dart
class UserModel {
  final int idUser;
  final String username;
  final String nama;
  final String email;
  final String nip;
  final String level;
  final DateTime tanggalLahir;
  final int totalKegiatan;
  final double totalPoin;
  final List<String> jabatan;
  final List<String> kegiatan;

  UserModel({
    required this.idUser,
    required this.username,
    required this.nama,
    required this.email,
    required this.nip,
    required this.level,
    required this.tanggalLahir,
    this.totalKegiatan = 0,
    this.totalPoin = 0,
    this.jabatan = const [],
    this.kegiatan = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      username: json['username'],
      nama: json['nama'],
      email: json['email'],
      nip: json['NIP'],
      level: json['level'],
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
      totalKegiatan: json['total_kegiatan'] ?? 0,
      totalPoin: double.tryParse(json['total_poin'].toString()) ?? 0.0,
      jabatan: json['jabatan'] != null 
          ? List<String>.from(json['jabatan'])
          : [],
      kegiatan: json['kegiatan'] != null 
          ? List<String>.from(json['kegiatan'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'username': username,
      'nama': nama,
      'email': email,
      'NIP': nip,
      'tanggal_lahir': tanggalLahir.toIso8601String(),
      'total_kegiatan': totalKegiatan,
      'total_poin': totalPoin,
      'jabatan': jabatan,
      'kegiatan': kegiatan,
    };
  }
}