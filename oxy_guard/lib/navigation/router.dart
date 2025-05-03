import 'package:OxyGuard/home/view/home_page.dart';
import 'package:OxyGuard/reset_password/reset_page.dart';
import 'package:OxyGuard/signup/singup_page.dart';
import 'package:OxyGuard/login/login_page.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:OxyGuard/splash/view/splash.dart';
import 'package:flutter/material.dart';

final Router router = Router.instance;

class Router {
  static Router get instance => sl<Router>();

  Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RoutesNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case RoutesNames.signup:
        return MaterialPageRoute(builder: (_) => const SingupPage());
      case RoutesNames.restorePassword:
        return MaterialPageRoute(builder: (_) => const ResetPage());
      case RoutesNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      default: 
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  void popUntil({bool Function(Route<dynamic>)? predicate}) {
    navigatorKey.currentState?.popUntil(predicate ?? ModalRoute.withName('/'));
  }

  Future<T?> push<T extends Object?>(String route) async {
    return navigatorKey.currentState?.pushNamed(
      route
    );
  }

  Future<T?> replace<T extends Object?>(String route) async {
    return navigatorKey.currentState?.pushReplacementNamed(
      route
    );
  }

  Future<T?> pushAndRemove<T extends Object?>(String route, {bool Function(Route<dynamic>)? predicate}) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      predicate ?? ModalRoute.withName('/'),
    );
  }
}
