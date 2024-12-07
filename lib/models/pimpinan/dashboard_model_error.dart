// dashboard_model_error.dart
class DashboardModelError {
  final bool status;
  final String message;

  DashboardModelError({
    required this.status,
    required this.message,
  });

  factory DashboardModelError.fromJson(Map<String, dynamic> json) {
    return DashboardModelError(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }
}