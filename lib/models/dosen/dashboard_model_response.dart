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
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }

  factory DashboardModelResponse.withError(String message) {
    return DashboardModelResponse(
      status: false,
      message: message,
      data: null,
    );
  }
}