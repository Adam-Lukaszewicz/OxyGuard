import 'dart:convert';

import 'package:oxy_guard/models/personnel/worker.dart';

class FinishedSquad {
  String name;
  int index;
  double averageUse;
  List<Worker?> workers;
  FinishedSquad(
      {required this.name,
      required this.index,
      required this.averageUse,
      required this.workers});
  FinishedSquad.fromJson(Map<String, dynamic> json)
      : this(
            name: json["Name"] as String,
            index: json["Index"] as int,
            averageUse: json["AverageUse"] as double,
            workers: (jsonDecode(json["Workers"]) as Iterable).map((w) {
              if (w != null) {
                return Worker.fromJson(w);
              } else {
                return null;
              }
            }).toList());

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Index": index,
      "AverageUse": averageUse,
      "Workers": jsonEncode(workers),
    };
  }
}
