class KegiatanError implements Exception {
  final String message;
  final Map<String, List<String>>? validationErrors;

  KegiatanError({
    required this.message,
    this.validationErrors,
  });

  factory KegiatanError.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? errors;
    if (json['errors'] != null) {
      errors = {};
      json['errors'].forEach((key, value) {
        if (value is List) {
          errors![key] = List<String>.from(value);
        }
      });
    }

    return KegiatanError(
      message: json['message'] ?? 'Terjadi kesalahan',
      validationErrors: errors,
    );
  }

  @override
  String toString() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      String errorMessages = validationErrors!.values
          .expand((element) => element)
          .join('\n');
      return errorMessages;
    }
    return message;
  }
}