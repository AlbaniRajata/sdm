// dashboard_model_response.dart
class DashboardModelResponse {
  final bool status;
  final String message;
  final dynamic data;

  DashboardModelResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardModelResponse.fromJson(Map<String, dynamic> json) {
    return DashboardModelResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'],
    );
  }
}