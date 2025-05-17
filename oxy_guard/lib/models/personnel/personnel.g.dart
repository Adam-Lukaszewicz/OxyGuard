// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personnel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Personnel _$PersonnelFromJson(Map<String, dynamic> json) => Personnel(
      uid: json['uid'] as String,
      id: json['id'] as String?,
      workers:
          (json['workers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PersonnelToJson(Personnel instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'workers': instance.workers,
    };
