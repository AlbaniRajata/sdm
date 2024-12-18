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
    final jenisDokumen = json['jenis_dokumen'] as String;
    
    return DokumenModel(
      idDokumen: json['id_dokumen'],
      namaDokumen: json['nama_dokumen'],
      jenisDokumen: jenisDokumen,
      filePath: json['file_path'],
    );
  }

  bool isSuratTugas() {
    return jenisDokumen.toLowerCase() == 'surat tugas';
  }
}