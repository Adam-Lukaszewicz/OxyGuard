// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedTeam _$FinishedTeamFromJson(Map<String, dynamic> json) => FinishedTeam(
      archivedSquadId: json['archivedSquadId'] as String,
      id: json['id'] as String?,
      name: json['name'] as String,
      averageConsumption: (json['averageConsumption'] as num).toDouble(),
      workers:
          (json['workers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FinishedTeamToJson(FinishedTeam instance) =>
    <String, dynamic>{
      'archivedSquadId': instance.archivedSquadId,
      'id': instance.id,
      'name': instance.name,
      'averageConsumption': instance.averageConsumption,
      'workers': instance.workers,
    };
