// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedTeam _$FinishedTeamFromJson(Map<String, dynamic> json) => FinishedTeam(
      archivedActionId: json['archivedActionId'] as String,
      id: json['id'] as String?,
      finishedSquads: (json['finishedSquads'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FinishedTeamToJson(FinishedTeam instance) =>
    <String, dynamic>{
      'archivedActionId': instance.archivedActionId,
      'id': instance.id,
      'finishedSquads': instance.finishedSquads,
    };
