class AnggotaAgenda {
  final int idAgendaAnggota;
  final int idAgenda;
  final int idAnggota;
  final String namaAgenda;

  AnggotaAgenda({
    required this.idAgendaAnggota,
    required this.idAgenda,
    required this.idAnggota,
    required this.namaAgenda,
  });

  factory AnggotaAgenda.fromJson(Map<String, dynamic> json) {
    return AnggotaAgenda(
      idAgendaAnggota: json['id_agenda_anggota'] ?? 0,
      idAgenda: json['id_agenda'] ?? 0,
      idAnggota: json['id_anggota'] ?? 0,
      namaAgenda: json['nama_agenda'] ?? '',
    );
  }
}

// agenda_item_model.dart
class AgendaItem {
  final int idAgendaAnggota;
  final int idAgenda;
  final String namaAgenda;

  AgendaItem({
    required this.idAgendaAnggota,
    required this.idAgenda,
    required this.namaAgenda,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) => AgendaItem(
    idAgendaAnggota: json["id_agenda_anggota"]?.toInt() ?? 0,
    idAgenda: json["id_agenda"]?.toInt() ?? 0,
    namaAgenda: json["nama_agenda"]?.toString() ?? '',
  );
}