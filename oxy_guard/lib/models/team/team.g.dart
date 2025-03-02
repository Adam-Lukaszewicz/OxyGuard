// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: json['id'] as String?,
      squadId: json['squadId'] as String,
      isInCrisis: json['isInCrisis'] as bool? ?? false,
      isWorking: json['isWorking'] as bool? ?? false,
      entryPressure: (json['entryPressure'] as num).toDouble(),
      safeReturnPressure: (json['safeReturnPressure'] as num?)?.toDouble(),
      returnPressure: (json['returnPressure'] as num?)?.toDouble(),
      criticalPressure: (json['criticalPressure'] as num).toDouble(),
      travelTime: (json['travelTime'] as num?)?.toInt() ?? 0,
      checks: (json['checks'] as List<dynamic>?)
          ?.map((e) => _$recordConvert(
                e,
                ($jsonValue) => (
                  DateTime.parse($jsonValue[r'$1'] as String),
                  ($jsonValue[r'$2'] as num).toDouble(),
                ),
              ))
          .toList(),
      oxygenUsageRate:
          (json['oxygenUsageRate'] as num?)?.toDouble() ?? 10.0 / 60.0,
      workingArea: json['workingArea'] as String?,
      firstWorker: json['firstWorker'] == null
          ? null
          : Worker.fromJson(json['firstWorker'] as Map<String, dynamic>),
      secondWorker: json['secondWorker'] == null
          ? null
          : Worker.fromJson(json['secondWorker'] as Map<String, dynamic>),
      thirdWorker: json['thirdWorker'] == null
          ? null
          : Worker.fromJson(json['thirdWorker'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'squadId': instance.squadId,
      'isInCrisis': instance.isInCrisis,
      'isWorking': instance.isWorking,
      'entryPressure': instance.entryPressure,
      'safeReturnPressure': instance.safeReturnPressure,
      'returnPressure': instance.returnPressure,
      'criticalPressure': instance.criticalPressure,
      'travelTime': instance.travelTime,
      'checks': instance.checks
          .map((e) => <String, dynamic>{
                r'$1': e.$1.toIso8601String(),
                r'$2': e.$2,
              })
          .toList(),
      'oxygenUsageRate': instance.oxygenUsageRate,
      'workingArea': instance.workingArea,
      'firstWorker': instance.firstWorker,
      'secondWorker': instance.secondWorker,
      'thirdWorker': instance.thirdWorker,
    };

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
