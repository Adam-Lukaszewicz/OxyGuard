import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'squad.g.dart';

@JsonSerializable()
class Squad {
  Squad({required this.actionId, String? id, required this.teams}) : id = id ?? const Uuid().v4();

  String actionId;

  String? id;

  List<String> teams;

  factory Squad.fromJson(Map<String, dynamic> json) => _$SquadFromJson(json);

  Map<String, dynamic> toJson() => _$SquadToJson(this);
}
