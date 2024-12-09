import 'package:sdm/models/dosen/agenda_model.dart';

class AgendaResponse {
  final String? status;
  final List<AgendaModel>? data;

  AgendaResponse({
    this.status,
    this.data,
  });

  factory AgendaResponse.fromJson(Map<String, dynamic> json) => AgendaResponse(
    status: json["status"],
    data: json["data"] == null ? [] : List<AgendaModel>.from(json["data"].map((x) => AgendaModel.fromJson(x))),
  );
}