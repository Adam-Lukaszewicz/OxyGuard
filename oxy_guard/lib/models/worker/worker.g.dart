// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Worker _$WorkerFromJson(Map<String, dynamic> json) => Worker(
      personnelId: json['personnelId'] as String,
      id: json['id'] as String?,
      name: json['name'] as String,
      surname: json['surname'] as String,
    );

Map<String, dynamic> _$WorkerToJson(Worker instance) => <String, dynamic>{
      'personnelId': instance.personnelId,
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
    };
