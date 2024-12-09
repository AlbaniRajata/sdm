// dosen_model.dart
class DosenModel {
  final int idKegiatan;
  final String jabatan;

  DosenModel({
    required this.idKegiatan,
    required this.jabatan,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      idKegiatan: json['id_kegiatan'],
      jabatan: json['jabatan'],
    );
  }
}