import 'package:OxyGuard/repositories/actions/api/actions_api.dart';

import '../../models/models.dart';

class ActionsRepository {
  const ActionsRepository({required ActionsApi actionsApi})
      : _actionsApi = actionsApi;

  final ActionsApi _actionsApi;

  Stream<List<Action>> getActions() => _actionsApi.getActions();

  Stream<List<Action>> getActionsByUserId(String userId) => _actionsApi.getActionsByUserId(userId);

  Stream<Action> getActionById(String id) => _actionsApi.getActionById(id);

  Future<void> saveAction(Action action) => _actionsApi.saveAction(action);

  Future<void> deleteAction(String id) => _actionsApi.deleteAction(id);
}
