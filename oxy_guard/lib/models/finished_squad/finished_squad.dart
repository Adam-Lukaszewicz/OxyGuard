import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'finished_squad.g.dart';

@JsonSerializable()
class FinishedSquad {
  FinishedSquad({required this.archivedTeamId, String? id, required this.name, required this.averageConsumption, required this.workers}) : id = id ?? const Uuid().v4();

  String archivedTeamId;

  String? id;

  String name;

  double averageConsumption;

  List<String> workers;

  factory FinishedSquad.fromJson(Map<String, dynamic> json) => _$FinishedSquadFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedSquadToJson(this);
}
