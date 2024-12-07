class StatistikPimpinan {
  final String nama;
  final int totalKegiatan;
  final double totalPoin;

  StatistikPimpinan({
    required this.nama,
    required this.totalKegiatan,
    required this.totalPoin,
  });

  factory StatistikPimpinan.fromJson(Map<String, dynamic> json) {
    return StatistikPimpinan(
      nama: json['nama'] ?? '',
      totalKegiatan: json['total_kegiatan'] ?? 0,
      totalPoin: double.tryParse(json['total_poin'].toString()) ?? 0.0,
    );
  }
}