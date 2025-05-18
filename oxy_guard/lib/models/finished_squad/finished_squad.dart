import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'finished_squad.g.dart';

@JsonSerializable()
class FinishedSquad {
  FinishedSquad({required this.archivedActionId, String? id, required this.finishedTeams}) : id = id ?? const Uuid().v4();

  String archivedActionId;

  String? id;

  List<String> finishedTeams;

  factory FinishedSquad.fromJson(Map<String, dynamic> json) => _$FinishedSquadFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedSquadToJson(this);
}
