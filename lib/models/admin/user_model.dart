// lib/models/user/user.dart
import 'package:flutter/foundation.dart';

class User {
  final int idUser;
  final String username;
  final String nama;
  final DateTime tanggalLahir;
  final String email;
  final String nip;
  final String level;

  User({
    required this.idUser,
    required this.username,
    required this.nama,
    required this.tanggalLahir,
    required this.email,
    required this.nip,
    required this.level,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        idUser: json['id_user'] is int ? json['id_user'] : int.tryParse(json['id_user'].toString()) ?? 0,
        username: json['username']?.toString() ?? '',
        nama: json['nama']?.toString() ?? '',
        tanggalLahir: DateTime.tryParse(json['tanggal_lahir']?.toString() ?? '') ?? DateTime.now(),
        email: json['email']?.toString() ?? '',
        nip: json['NIP']?.toString() ?? '',
        level: json['level']?.toString().toLowerCase() ?? 'user',
      );
    } catch (e) {
      debugPrint('Error parsing User: $e');
      return User(
        idUser: 0,
        username: '',
        nama: '',
        tanggalLahir: DateTime.now(),
        email: '',
        nip: '',
        level: 'user',
      );
    }
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