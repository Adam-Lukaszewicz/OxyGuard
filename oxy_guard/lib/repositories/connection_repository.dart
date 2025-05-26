import 'dart:async';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
class ConnectionRepository {
  ConnectionRepository();

  bool offlineMode = false;

  Future<void> checkInternetConnection() async {
    offlineMode = !await InternetConnection().hasInternetAccess;
  }

}
