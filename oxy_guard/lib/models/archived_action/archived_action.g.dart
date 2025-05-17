// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchivedAction _$ArchivedActionFromJson(Map<String, dynamic> json) =>
    ArchivedAction(
      uid: json['uid'] as String,
      id: json['id'] as String?,
      actionLocation: _$JsonConverterFromJson<Map<String, dynamic>, Position>(
          json['actionLocation'], const PositionConverter().fromJson),
      endTime: DateTime.parse(json['endTime'] as String),
      finishedTeams: (json['finishedTeams'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ArchivedActionToJson(ArchivedAction instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'id': instance.id,
      'actionLocation': _$JsonConverterToJson<Map<String, dynamic>, Position>(
          instance.actionLocation, const PositionConverter().toJson),
      'endTime': instance.endTime.toIso8601String(),
      'finishedTeams': instance.finishedTeams,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
