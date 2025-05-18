import '../../../models/models.dart';

abstract class ActionsApi {
  const ActionsApi();

  Stream<List<Action>> getActions();

  Stream<List<Action>> getActionsByUserId(String userId);

  Stream<Action> getActionById(String id);
  
  Future<void> saveAction(Action action);

  Future<void> deleteAction(String id);
}

class ActionNotFoundException implements Exception{}