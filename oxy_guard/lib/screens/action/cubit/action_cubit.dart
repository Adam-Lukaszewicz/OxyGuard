import 'dart:async';

import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/actions/actions_repository.dart';
import 'package:OxyGuard/repositories/squad/squad_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/screens/action/cubit/action_state.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionCubit extends Cubit<ActionState> {
  ActionCubit() : super(ActionInitial());

  final ActionsRepository _actionsRepository = sl();
  final SquadRepository _squadRepository = sl();
  final UserRepository _userRepository = sl();

  StreamSubscription<dynamic>? _subscription;

  void init(String? actionId) async {
    if (actionId == null) {
      final Action action = Action(uid: _userRepository.user.id, squads: []);
      await _actionsRepository.saveAction(action);
      actionId = action.id!;
    }

    _subscription = _actionsRepository.getActionById(actionId).listen((Action action) async {
      final List<Squad> squads = await _squadRepository.getSquadsByActionId(action.id!).first;

      emit(ActionLoadedState(action: action, squads: squads));
    });
  }

  Future<void> endAction(Action action) async {
    //TODO: after figuring out how finished Teams and Squads will be stored, implement this accordingly
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
