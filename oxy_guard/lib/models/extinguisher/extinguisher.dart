import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'extinguisher.g.dart';

@JsonSerializable()
class Extinguisher {
  String? id;

  String uid;

  String serialNumber;

  DateTime expirationDate;

  Extinguisher(
      {String? id,
      required this.uid,
      required this.serialNumber,
      required this.expirationDate})
      : id = id ?? const Uuid().v4();

  factory Extinguisher.fromJson(Map<String, dynamic> json) => _$ExtinguisherFromJson(json);

  Map<String, dynamic> toJson() => _$ExtinguisherToJson(this);
}
