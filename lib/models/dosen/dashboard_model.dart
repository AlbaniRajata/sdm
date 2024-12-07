// dashboard_model.dart
class DashboardModel {
  final int totalKegiatanJTI;
  final int totalKegiatanNonJTI;

  DashboardModel({
    required this.totalKegiatanJTI,
    required this.totalKegiatanNonJTI,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalKegiatanJTI: json['data'] as int,
      totalKegiatanNonJTI: json['data'] as int,
    );
  }
}