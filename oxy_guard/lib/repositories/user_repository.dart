import 'package:OxyGuard/models/models.dart';

class UserRepository {
  User? _user;

  User get user {
    return _user ?? User.empty;
  }

  set user(User value){
    _user = value;
  }

  void logOut(){
    _user = null;
  }
}
