import 'dart:convert';

class FinishedSquad{
  String name;
  int index;
  double averageUse;
  FinishedSquad({required this.name, required this.index, required this.averageUse});
  FinishedSquad.fromJson(Map<String, dynamic> json): this(
    name: json["Name"] as String,
    index: json["Index"] as int,
    averageUse: json["AverageUse"] as double
    );

  Map<String, dynamic> toJson(){
    return{
      "Name": name,
      "Index": index,
      "AverageUse": averageUse,
    };
  }
}