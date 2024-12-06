class StatistikAdminError {
  final String message;

  StatistikAdminError({required this.message});

  factory StatistikAdminError.fromJson(Map<String, dynamic> json) {
    return StatistikAdminError(
      message: json['message'] ?? 'Unknown error',
    );
  }
}