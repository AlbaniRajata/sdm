class AgendaModel {
  final int? idKegiatan;
  final String? namaKegiatan;
  final String? tempatKegiatan;
  final String? deskripsiKegiatan;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? tanggalAcara;
  final List<AnggotaAgenda>? anggota;
  final List<AgendaDetail>? agenda;

  AgendaModel({
    this.idKegiatan,
    this.namaKegiatan,
    this.tempatKegiatan,
    this.deskripsiKegiatan,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.tanggalAcara,
    this.anggota,
    this.agenda,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) => AgendaModel(
    idKegiatan: json["id_kegiatan"],
    namaKegiatan: json["nama_kegiatan"],
    tempatKegiatan: json["tempat_kegiatan"],
    deskripsiKegiatan: json["deskripsi_kegiatan"],
    tanggalMulai: json["tanggal_mulai"],
    tanggalSelesai: json["tanggal_selesai"],
    tanggalAcara: json["tanggal_acara"],
    anggota: json["anggota"] == null ? [] : List<AnggotaAgenda>.from(json["anggota"].map((x) => AnggotaAgenda.fromJson(x))),
    agenda: json["agenda"] == null ? [] : List<AgendaDetail>.from(json["agenda"].map((x) => AgendaDetail.fromJson(x))),
  );
}

class AnggotaAgenda {
  final int? idAnggota;
  final int? idUser;
  final String? nama;
  final JabatanAnggota? jabatan;

  AnggotaAgenda({
    this.idAnggota,
    this.idUser,
    this.nama,
    this.jabatan,
  });

  factory AnggotaAgenda.fromJson(Map<String, dynamic> json) => AnggotaAgenda(
    idAnggota: json["id_anggota"],
    idUser: json["id_user"],
    nama: json["user"]["nama"],
    jabatan: json["jabatan"] == null ? null : JabatanAnggota.fromJson(json["jabatan"]),
  );
}

class AgendaDetail {
  final int? idAgenda;
  final String? namaAgenda;
  final String? keterangan;
  final List<AgendaAnggota>? agendaAnggota;

  AgendaDetail({
    this.idAgenda,
    this.namaAgenda,
    this.keterangan,
    this.agendaAnggota,
  });

  factory AgendaDetail.fromJson(Map<String, dynamic> json) => AgendaDetail(
    idAgenda: json["id_agenda"],
    namaAgenda: json["nama_agenda"],
    keterangan: json["keterangan"],
    agendaAnggota: json["agenda_anggota"] == null ? [] : List<AgendaAnggota>.from(json["agenda_anggota"].map((x) => AgendaAnggota.fromJson(x))),
  );
}

class AgendaAnggota {
  final int? idAnggota;
  final String? status;
  final String? catatan;

  AgendaAnggota({
    this.idAnggota,
    this.status,
    this.catatan,
  });

  factory AgendaAnggota.fromJson(Map<String, dynamic> json) => AgendaAnggota(
    idAnggota: json["id_anggota"],
    status: json["status"],
    catatan: json["catatan"],
  );
}

class JabatanAnggota {
  final int? idJabatanKegiatan;
  final String? namaJabatan;

  JabatanAnggota({
    this.idJabatanKegiatan,
    this.namaJabatan,
  });

  factory JabatanAnggota.fromJson(Map<String, dynamic> json) => JabatanAnggota(
    idJabatanKegiatan: json["id_jabatan_kegiatan"],
    namaJabatan: json["nama_jabatan"],
  );
}