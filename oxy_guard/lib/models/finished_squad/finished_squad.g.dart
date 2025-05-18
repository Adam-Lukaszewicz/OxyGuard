// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_squad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedSquad _$FinishedSquadFromJson(Map<String, dynamic> json) =>
    FinishedSquad(
      archivedActionId: json['archivedActionId'] as String,
      id: json['id'] as String?,
      finishedTeams: (json['finishedTeams'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FinishedSquadToJson(FinishedSquad instance) =>
    <String, dynamic>{
      'archivedActionId': instance.archivedActionId,
      'id': instance.id,
      'finishedTeams': instance.finishedTeams,
    };
