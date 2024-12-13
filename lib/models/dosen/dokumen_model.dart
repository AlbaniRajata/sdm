class DokumenModel {
  final int idDokumen;
  final String namaDokumen;
  final String jenisDokumen;
  final String filePath;

  DokumenModel({
    required this.idDokumen,
    required this.namaDokumen,
    required this.jenisDokumen,
    required this.filePath,
  });

  factory DokumenModel.fromJson(Map<String, dynamic> json) {
    return DokumenModel(
      idDokumen: json['id_dokumen'],
      namaDokumen: json['nama_dokumen'],
      jenisDokumen: json['jenis_dokumen'],
      filePath: json['file_path'],
    );
  }
}