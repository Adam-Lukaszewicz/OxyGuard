import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'finished_team.g.dart';

@JsonSerializable()
class FinishedTeam {
  FinishedTeam({required this.archivedActionId, String? id, required this.finishedSquads})
      : id = id ?? const Uuid().v4();

  String archivedActionId;

  String? id;

  List<String> finishedSquads;

  factory FinishedTeam.fromJson(Map<String, dynamic> json) => _$FinishedTeamFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedTeamToJson(this);
}
