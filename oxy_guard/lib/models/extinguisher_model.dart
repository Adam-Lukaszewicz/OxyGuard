import 'package:oxy_guard/services/global_service.dart';

class ExtinguisherModel {
  String? id;
  String serial;
  DateTime expirationDate;
  ExtinguisherModel({this.id, required this.serial, required this.expirationDate});
  ExtinguisherModel.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            serial: json["serial"],
            expirationDate: DateTime.parse(json["expirationDate"]));
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "serial": serial,
      "expirationDate": expirationDate.toUtc().toIso8601String()
    };
  }

  void setId(String id){
    this.id = id;
    GlobalService.databaseSevice.updateAtest(this);
  }

  void updateDate(DateTime newDate){
    expirationDate = newDate;
    GlobalService.databaseSevice.updateAtest(this);
  }

  void remove(){
    GlobalService.databaseSevice.removeAtest(this);
  }
}
