import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';

class PositionConverter implements JsonConverter<Position, Map<String, dynamic>> {
  const PositionConverter();

  @override
  Map<String, dynamic> toJson(Position object) => object.toJson();

  @override
  Position fromJson(Map<String, dynamic> json) => Position.fromMap(json);
}
