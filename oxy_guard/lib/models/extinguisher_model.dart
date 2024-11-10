import 'package:oxy_guard/services/global_service.dart';

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
    String? id = await GlobalService.databaseSevice.getTestIdBySerial(serial);
    if(id != null){
      GlobalService.databaseSevice.updateAtest(this, id);
    }
  }

  void remove() async {
    String? id = await GlobalService.databaseSevice.getTestIdBySerial(serial);
    if(id != null){
    GlobalService.databaseSevice.removeAtest(this, id);
    }
  }
}
