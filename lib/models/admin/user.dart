class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  get nama => null;
  get level => null;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  static fromJson(item) {}
}