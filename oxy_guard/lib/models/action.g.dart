// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
      uid: json['uid'] as String,
      id: json['id'] as String?,
      squads: (json['squads'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Squad.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      actionLocation: _$JsonConverterFromJson<Map<String, dynamic>, Position>(
          json['actionLocation'], const PositionConverter().fromJson),
      actionName: json['actionName'] as String?,
    );

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'uid': instance.uid,
      'id': instance.id,
      'squads': instance.squads,
      'actionLocation': _$JsonConverterToJson<Map<String, dynamic>, Position>(
          instance.actionLocation, const PositionConverter().toJson),
      'actionName': instance.actionName,
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
