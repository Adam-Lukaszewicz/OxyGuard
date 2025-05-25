import 'package:OxyGuard/models/worker/worker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  String? id;

  String squadId;

  String name;

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
      required this.name,
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

  double getOxygenRemaining() {
    if (isWorking) {
      return checks.last.$2 - (oxygenUsageRate * DateTime.now().difference(checks.last.$1).inSeconds);
    } else {
      return checks.last.$2;
    }
  }

  int getTimeRemaining() {
    //TODO: figure out naming conventions for entry / exit pressures and also return and safe return to standardize,
    // then replace the -60 with the according pressure
    // Also, maybe merge the two functions and parametrize to avoid duplicate code
    final int remainingTime = (getOxygenRemaining() - 60.0) ~/ oxygenUsageRate;
    if (remainingTime > 0) {
      return remainingTime;
    } else {
      return 0;
    }
  }

  int getTimeRemainingInCrisis() {
    final int remainingTime = getOxygenRemaining() ~/ (15 / 60);
    if (remainingTime > 0) {
      return remainingTime;
    } else {
      return 0;
    }
  }

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
