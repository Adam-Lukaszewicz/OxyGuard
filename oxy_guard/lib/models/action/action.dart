import 'package:OxyGuard/models/converters/position_converter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'action.g.dart';

@JsonSerializable()
class Action {
  Action({required this.uid, String? id, this.actionLocation, this.actionName, required this.squads}) : id = id ?? const Uuid().v4();

  String uid;

  String? id;

  @PositionConverter()
  Position? actionLocation;

  String? actionName;

  List<String> squads;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
