class KegiatanResponse {
  final bool status;
  final String message;
  final dynamic data;

  KegiatanResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory KegiatanResponse.fromJson(Map<String, dynamic> json) {
    return KegiatanResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class KegiatanListResponse extends KegiatanResponse {
  final List<dynamic> data;

  KegiatanListResponse({
    required bool status,
    required String message,
    required this.data,
  }) : super(status: status, message: message);

  factory KegiatanListResponse.fromJson(Map<String, dynamic> json) {
    return KegiatanListResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}