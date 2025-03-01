import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'squad.g.dart';

@JsonSerializable()
class Squad {
  Squad({String? id}) : id = id ?? const Uuid().v4();

  String? id;

  factory Squad.fromJson(Map<String, dynamic> json) => _$SquadFromJson(json);

  Map<String, dynamic> toJson() => _$SquadToJson(this);
}
