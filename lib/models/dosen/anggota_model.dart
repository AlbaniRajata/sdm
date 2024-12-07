class AnggotaModel {
  final int idAnggota;
  final int idUser;
  final String nama;
  final String jabatanNama;
  final double poin;

  AnggotaModel({
    required this.idAnggota,
    required this.idUser,
    required this.nama,
    required this.jabatanNama,
    required this.poin,
  });

  factory AnggotaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaModel(
      idAnggota: json['id_anggota'],
      idUser: json['id_user'],
      nama: json['nama'],
      jabatanNama: json['jabatan'],
      poin: double.tryParse(json['poin'].toString()) ?? 0.0,
    );
  }
}