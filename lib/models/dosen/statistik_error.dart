class StatistikDosenError {
  final String message;

  StatistikDosenError({required this.message});

  factory StatistikDosenError.fromJson(Map<String, dynamic> json) {
    return StatistikDosenError(
      message: json['message'] ?? 'Unknown error',
    );
  }
}