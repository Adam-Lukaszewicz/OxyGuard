import 'package:OxyGuard/models/models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'action.g.dart';

@JsonSerializable()
class Action {
  Action(
      {required this.uid,
      String? id,
      this.squads = const {},
      this.actionLocation,
      this.actionName})
      : id = id ?? const Uuid().v4();

  String uid;

  String? id;

  Map<String, Squad> squads;

  @PositionConverter()
  Position? actionLocation;

  String? actionName;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}

class PositionConverter
    implements JsonConverter<Position, Map<String, dynamic>> {
  const PositionConverter();

  @override
  Map<String, dynamic> toJson(Position object) => object.toJson();

  @override
  Position fromJson(Map<String, dynamic> json) => Position.fromMap(json);
}
