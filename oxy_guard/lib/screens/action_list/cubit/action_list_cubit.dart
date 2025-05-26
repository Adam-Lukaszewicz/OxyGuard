import 'dart:async';

import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/actions/actions_repository.dart';
import 'package:OxyGuard/repositories/connection_repository.dart';
import 'package:OxyGuard/repositories/location_repository.dart';
import 'package:OxyGuard/repositories/user_repository.dart';
import 'package:OxyGuard/screens/action_list/cubit/action_list_state.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class ActionListCubit extends Cubit<ActionListState> {
  ActionListCubit() : super(ActionListInitial());

  final UserRepository _userRepository = sl();
  final ActionsRepository _actionsRepository = sl();
  final LocationRepository _locationRepository = sl();
  final ConnectionRepository _connectionRepository = sl();

  StreamSubscription<dynamic>? _subscription;

  void init() {
    //TODO: offline actions (chech connection repo then change initialization accordingly)
    _subscription = _actionsRepository.getActionsByUserId(_userRepository.user.id).listen((List<Action> actions) async {
      if (_locationRepository.hasPermission()) {
        final Position currentPosition = await Geolocator.getCurrentPosition();
        actions.sort((Action a, Action b) {
          //This configuration places actions without coordinates at the very bottom of the list - reverse this
          //if needed.
          if (a.actionLocation == null && b.actionLocation == null) return 0;
          if (a.actionLocation == null) return -1;
          if (b.actionLocation == null) return 1;
          final double distanceA = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude,
              a.actionLocation!.latitude, a.actionLocation!.longitude);
          final double distanceB = Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude,
              b.actionLocation!.latitude, b.actionLocation!.longitude);
          return distanceA.compareTo(distanceB);
        });

        emit(ActionListLoadedState(actions: actions, offlineMode: false));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
