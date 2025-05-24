import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'worker.g.dart';

@JsonSerializable()
class Worker {
  String personnelId;

  String? id;

  String name;

  String surname;

  Worker({required this.personnelId, String? id, required this.name, required this.surname}) : id = id ?? const Uuid().v4();

  factory Worker.fromJson(Map<String, dynamic> json) => _$WorkerFromJson(json);

  Map<String, dynamic> toJson() => _$WorkerToJson(this);
}
