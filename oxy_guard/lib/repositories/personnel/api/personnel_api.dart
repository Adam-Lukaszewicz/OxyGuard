import '../../../models/models.dart';

abstract class PersonnelApi {
  const PersonnelApi();

  Stream<List<Personnel>> getPersonnel();

  Stream<List<Personnel>> getPersonnelByUserId(String userId);

  Future<void> savePersonnel(Personnel personnel);

  Future<void> deletePersonnel(String id);
}

class PersonnelNotFoundException implements Exception {}