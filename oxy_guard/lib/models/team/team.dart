import 'package:OxyGuard/models/worker/worker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  String? id;

  String squadId;

  bool isInCrisis;

  bool isWorking;

  double entryPressure;

  double safeReturnPressure;

  double returnPressure;

  double criticalPressure;

  int travelTime;

  List<(DateTime, double)> checks;

  double oxygenUsageRate;

  String? workingArea;

  Worker? firstWorker;

  Worker? secondWorker;

  Worker? thirdWorker;

  Team(
      {String? id,
      required this.squadId,
      this.isInCrisis = false,
      this.isWorking = false,
      required this.entryPressure,
      double? safeReturnPressure,
      double? returnPressure,
      required this.criticalPressure,
      this.travelTime = 0,
      List<(DateTime, double)>? checks,
      this.oxygenUsageRate = 10.0 / 60.0,
      this.workingArea,
      this.firstWorker,
      this.secondWorker,
      this.thirdWorker})
      : id = id ?? const Uuid().v4(),
        safeReturnPressure = safeReturnPressure ?? criticalPressure,
        returnPressure = returnPressure ?? criticalPressure,
        checks = checks ?? <(DateTime, double)>[];

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
