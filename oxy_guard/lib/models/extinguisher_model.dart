import 'package:oxy_guard/services/database_service.dart';
import 'package:watch_it/watch_it.dart';

class ExtinguisherModel {
  String serial;
  DateTime expirationDate;
  ExtinguisherModel({required this.serial, required this.expirationDate});
  ExtinguisherModel.fromJson(Map<String, dynamic> json)
      : this(
            serial: json["serial"],
            expirationDate: DateTime.parse(json["expirationDate"]));
  Map<String, dynamic> toJson() {
    return {
      "serial": serial,
      "expirationDate": expirationDate.toUtc().toIso8601String()
    };
  }

  void updateDate(DateTime newDate) async {
    expirationDate = newDate;
    String? id = await GetIt.I.get<DatabaseService>().getAtestIdBySerial(serial);
    if(id != null){
      GetIt.I.get<DatabaseService>().updateAtest(this, id);
    }
  }

  void remove() async {
    String? id = await GetIt.I.get<DatabaseService>().getAtestIdBySerial(serial);
    if(id != null){
    GetIt.I.get<DatabaseService>().removeAtest(this, id);
    }
  }
}
