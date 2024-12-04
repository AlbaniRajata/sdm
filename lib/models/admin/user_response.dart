// lib/models/user/user_response.dart
import 'package:flutter/material.dart';
import 'package:sdm/models/admin/user_model.dart';

class UserResponse {
  final String status;
  final String? message;
  final dynamic data;

  UserResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString(),
      data: json['data'],
    );
  }

  bool get isSuccess => status.toLowerCase() == 'success';

  List<User> getUserList() {
    try {
      if (data == null) return [];
      
      if (data is List) {
        return List<User>.from(
          (data as List).map((item) {
            if (item is Map<String, dynamic>) {
              return User.fromJson(item);
            }
            return User(
              idUser: 0,
              username: '',
              nama: '',
              tanggalLahir: DateTime.now(),
              email: '',
              nip: '',
              level: 'user',
            );
          }),
        );
      }
      
      if (data is Map<String, dynamic>) {
        return [User.fromJson(data)];
      }
      
      return [];
    } catch (e) {
      debugPrint('Error parsing userList: $e');
      return [];
    }
  }
}