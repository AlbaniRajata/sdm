class StatistikPimpinanError {
  final String message;

  StatistikPimpinanError({required this.message});

  factory StatistikPimpinanError.fromJson(Map<String, dynamic> json) {
    return StatistikPimpinanError(
      message: json['message'] ?? 'Unknown error',
    );
  }
}