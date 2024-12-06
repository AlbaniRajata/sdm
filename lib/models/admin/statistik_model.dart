class StatistikAdmin {
  final String nama;
  final int totalKegiatan;
  final double totalPoin;

  StatistikAdmin({
    required this.nama,
    required this.totalKegiatan,
    required this.totalPoin,
  });

  factory StatistikAdmin.fromJson(Map<String, dynamic> json) {
    return StatistikAdmin(
      nama: json['nama'] ?? '',
      totalKegiatan: json['total_kegiatan'] ?? 0,
      totalPoin: double.tryParse(json['total_poin'].toString()) ?? 0.0,
    );
  }
}