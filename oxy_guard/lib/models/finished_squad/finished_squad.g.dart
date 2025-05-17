// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_squad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedSquad _$FinishedSquadFromJson(Map<String, dynamic> json) =>
    FinishedSquad(
      archivedTeamId: json['archivedTeamId'] as String,
      id: json['id'] as String?,
      name: json['name'] as String,
      averageConsumption: (json['averageConsumption'] as num).toDouble(),
      workers:
          (json['workers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FinishedSquadToJson(FinishedSquad instance) =>
    <String, dynamic>{
      'archivedTeamId': instance.archivedTeamId,
      'id': instance.id,
      'name': instance.name,
      'averageConsumption': instance.averageConsumption,
      'workers': instance.workers,
    };
