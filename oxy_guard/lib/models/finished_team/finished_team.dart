import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'finished_team.g.dart';

@JsonSerializable()
class FinishedTeam {
  FinishedTeam(
      {required this.archivedSquadId,
      String? id,
      required this.uid,
      required this.name,
      required this.averageConsumption,
      required this.workers})
      : id = id ?? const Uuid().v4();

  String archivedSquadId;

  String? id;

  String uid;

  String name;

  double averageConsumption;

  List<String> workers;

  factory FinishedTeam.fromJson(Map<String, dynamic> json) => _$FinishedTeamFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedTeamToJson(this);
}
