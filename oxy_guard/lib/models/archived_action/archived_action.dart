import 'package:OxyGuard/models/converters/position_converter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'archived_action.g.dart';

@JsonSerializable()
class ArchivedAction {
  ArchivedAction({required this.uid, String? id, this.actionLocation, required this.endTime, required this.finishedTeams})
      : id = id ?? const Uuid().v4();

  String uid;

  String? id;

  @PositionConverter()
  Position? actionLocation;

  DateTime endTime;

  List<String> finishedTeams;

  factory ArchivedAction.fromJson(Map<String, dynamic> json) => _$ArchivedActionFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivedActionToJson(this);
}