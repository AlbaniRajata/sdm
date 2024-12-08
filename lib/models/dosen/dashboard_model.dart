class DashboardModel {
  final int totalKegiatan;
  final int totalKegiatanJti;
  final int totalKegiatanNonJti;

  DashboardModel({
    required this.totalKegiatan,
    required this.totalKegiatanJti,
    required this.totalKegiatanNonJti,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalKegiatan: json['total_kegiatan'] ?? 0,
      totalKegiatanJti: json['total_kegiatan_jti'] ?? 0,
      totalKegiatanNonJti: json['total_kegiatan_non_jti'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_kegiatan': totalKegiatan,
      'total_kegiatan_jti': totalKegiatanJti,
      'total_kegiatan_non_jti': totalKegiatanNonJti,
    };
  }
}