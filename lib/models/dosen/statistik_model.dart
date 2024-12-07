import 'package:sdm/models/dosen/statistik_data.dart';

class StatistikModel {
  List<StatistikItem>? statistik;
  double? totalPoin;

  StatistikModel({this.statistik, this.totalPoin});

  StatistikModel.fromJson(Map<String, dynamic> json) {
    if (json['statistik'] != null) {
      statistik = <StatistikItem>[];
      json['statistik'].forEach((v) {
        statistik!.add(StatistikItem.fromJson(v));
      });
    }
    totalPoin = double.tryParse(json['total_poin'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (statistik != null) {
      data['statistik'] = statistik!.map((v) => v.toJson()).toList();
    }
    data['total_poin'] = totalPoin;
    return data;
  }
}