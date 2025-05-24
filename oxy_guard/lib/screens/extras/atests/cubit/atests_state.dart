import 'package:OxyGuard/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AtestsState extends Equatable {
  @override
  List<Object?> get props => [];

  AtestsState copyWith();
}

class AtestsInitial extends AtestsState {
  @override
  AtestsState copyWith() {
    return this;
  }
}

class AtestsLoadedState extends AtestsState {
  AtestsLoadedState({required this.atestsList});

  final List<Extinguisher> atestsList;

  @override
  AtestsState copyWith({List<Extinguisher>? atestsList}) {
    return AtestsLoadedState(atestsList: atestsList ?? this.atestsList);
  }

  @override
  List<Object?> get props => [atestsList];
}
