class StatistikDosen {
  final String nama;
  final int totalKegiatan;
  final double totalPoin;

  StatistikDosen({
    required this.nama,
    required this.totalKegiatan,
    required this.totalPoin,
  });

  factory StatistikDosen.fromJson(Map<String, dynamic> json) {
    return StatistikDosen(
      nama: json['nama'] ?? '',
      totalKegiatan: json['total_kegiatan'] ?? 0,
      totalPoin: double.tryParse(json['total_poin'].toString()) ?? 0.0,
    );
  }
}