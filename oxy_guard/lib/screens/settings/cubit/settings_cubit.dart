import 'package:OxyGuard/screens/settings/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void init() {
    emit(SettingsLoadedState());
  }
}
