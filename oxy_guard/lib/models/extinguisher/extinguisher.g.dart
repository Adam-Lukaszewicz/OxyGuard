// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extinguisher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Extinguisher _$ExtinguisherFromJson(Map<String, dynamic> json) => Extinguisher(
      id: json['id'] as String?,
      uid: json['uid'] as String,
      serialNumber: json['serialNumber'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
    );

Map<String, dynamic> _$ExtinguisherToJson(Extinguisher instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'serialNumber': instance.serialNumber,
      'expirationDate': instance.expirationDate.toIso8601String(),
    };
