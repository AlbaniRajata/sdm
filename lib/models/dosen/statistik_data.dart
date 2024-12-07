class StatistikItem {
  String? namaKegiatan;
  String? jabatan;
  double? poin;
  String? tanggalAcara;

  StatistikItem({
    this.namaKegiatan,
    this.jabatan,
    this.poin,
    this.tanggalAcara,
  });

  StatistikItem.fromJson(Map<String, dynamic> json) {
    namaKegiatan = json['nama_kegiatan'];
    jabatan = json['jabatan'];
    poin = double.tryParse(json['poin'].toString()) ?? 0.0;
    tanggalAcara = json['tanggal_acara'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_kegiatan'] = namaKegiatan;
    data['jabatan'] = jabatan;
    data['poin'] = poin;
    data['tanggal_acara'] = tanggalAcara;
    return data;
  }
}