import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.photo,
    this.name,
    this.actions,
    this.archive,
    this.extinguishers,
  });

  /// The current user's ongoing actions.
  final List<dynamic>? actions;

  /// The current user's id.
  final String id;

  /// The current user's archived actions.
  final List<dynamic>? archive;

  /// The current user's tracked extinguishers.
  final List<dynamic>? extinguishers;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// The current user's email address.
  final String? email;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  @override
  List<Object?> get props => [email, id, name, photo];
}