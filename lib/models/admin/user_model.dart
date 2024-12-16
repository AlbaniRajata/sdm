class UserModel {
  final int idUser;
  final String username;
  final String nama;
  final DateTime tanggalLahir;
  final String email;
  final String nip;
  final String level;

  UserModel({
    required this.idUser,
    required this.username,
    required this.nama,
    required this.tanggalLahir,
    required this.email,
    required this.nip,
    required this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],
      username: json['username'],
      nama: json['nama'],
      tanggalLahir: DateTime.parse(json['tanggal_lahir']),
      email: json['email'],
      nip: json['NIP'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_user': idUser,
    'username': username,
    'nama': nama,
    'tanggal_lahir': tanggalLahir.toIso8601String(),
    'email': email,
    'NIP': nip,
    'level': level,
  };
}