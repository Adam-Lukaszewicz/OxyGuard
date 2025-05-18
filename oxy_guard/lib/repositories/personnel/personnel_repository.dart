import 'package:OxyGuard/repositories/personnel/api/personnel_api.dart';

import '../../models/models.dart';

class PersonnelRepository {
  const PersonnelRepository({required PersonnelApi personnelApi})
      : _personnelApi = personnelApi;

  final PersonnelApi _personnelApi;

  Stream<List<Personnel>> getPersonnel() => _personnelApi.getPersonnel();

  Stream<List<Personnel>> getPersonnelByUserId(String userId) => _personnelApi.getPersonnelByUserId(userId);

  Stream<Personnel> getPersonnelById(String id) => _personnelApi.getPersonnelById(id);

  Future<void> savePersonnel(Personnel personnel) => _personnelApi.savePersonnel(personnel);

  Future<void> deletePersonnel(String id) => _personnelApi.deletePersonnel(id);
}

class PersonnelNotFoundException implements Exception {}