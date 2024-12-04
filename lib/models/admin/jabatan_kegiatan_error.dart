class JabatanKegiatanError {
  final bool status;
  final String message;
  final Map<String, List<String>>? errors;

  JabatanKegiatanError({
    required this.status,
    required this.message,
    this.errors,
  });

  factory JabatanKegiatanError.fromJson(Map<String, dynamic> json) {
    return JabatanKegiatanError(
      status: json['status'] ?? false,
      message: json['message'] ?? 'Unknown error occurred',
      errors: json['errors'] != null
          ? Map<String, List<String>>.from(
              json['errors'].map(
                (key, value) => MapEntry(
                  key,
                  (value as List).map((e) => e.toString()).toList(),
                ),
              ),
            )
          : null,
    );
  }

  String getErrorMessage() {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.values.first.first;
    }
    return message;
  }
}