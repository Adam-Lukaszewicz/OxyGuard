// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Squad _$SquadFromJson(Map<String, dynamic> json) => Squad(
      actionId: json['actionId'] as String,
      id: json['id'] as String?,
      teams: (json['teams'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SquadToJson(Squad instance) => <String, dynamic>{
      'actionId': instance.actionId,
      'id': instance.id,
      'teams': instance.teams,
    };
