// dashboard_model.dart
class DashboardModel {
  final int totalDosen;
  final int totalKegiatanJTI;
  final int totalKegiatanNonJTI;

  DashboardModel({
    required this.totalDosen,
    required this.totalKegiatanJTI,
    required this.totalKegiatanNonJTI,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalDosen: json['data'] as int,
      totalKegiatanJTI: json['data'] as int,
      totalKegiatanNonJTI: json['data'] as int,
    );
  }
}