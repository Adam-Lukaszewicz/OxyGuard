import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'personnel.g.dart';

@JsonSerializable()
class Personnel {
  Personnel({required this.uid, String? id, required this.workers}) : id = id ?? const Uuid().v4();

  String? id;

  String uid;

  List<String> workers;

  factory Personnel.fromJson(Map<String, dynamic> json) => _$PersonnelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonnelToJson(this);
}
