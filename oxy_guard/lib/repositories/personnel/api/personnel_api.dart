import '../../../models/models.dart';

abstract class PersonnelApi {
  const PersonnelApi();

  Stream<List<Personnel>> getPersonnel();

  Stream<Personnel> getPersonnelByUserId(String userId);

  Stream<Personnel> getPersonnelById(String id);

  Future<void> savePersonnel(Personnel personnel);

  Future<void> deletePersonnel(String id);
}

class PersonnelNotFoundException implements Exception {}