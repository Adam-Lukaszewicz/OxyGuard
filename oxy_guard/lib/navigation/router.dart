import 'package:OxyGuard/screens/action/action_page.dart';
import 'package:OxyGuard/screens/extras/account/account_page.dart';
import 'package:OxyGuard/screens/extras/archive/archive_page.dart';
import 'package:OxyGuard/screens/extras/atests/atests_page.dart';
import 'package:OxyGuard/screens/extras/extras_page.dart';
import 'package:OxyGuard/screens/extras/team/team_page.dart';
import 'package:OxyGuard/screens/home/home_page.dart';
import 'package:OxyGuard/screens/reset_password/reset_page.dart';
import 'package:OxyGuard/screens/settings/settings_page.dart';
import 'package:OxyGuard/screens/signup/singup_page.dart';
import 'package:OxyGuard/screens/login/login_page.dart';
import 'package:OxyGuard/navigation/routes_names.dart';
import 'package:OxyGuard/service_locator.dart';
import 'package:OxyGuard/screens/splash/view/splash.dart';
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
      case RoutesNames.extras:
        return MaterialPageRoute(builder: (_) => const ExtrasPage());
      case RoutesNames.action:
        return MaterialPageRoute(
            builder: (_) => ActionPage(
                  actionId: settings.arguments as String?,
                ));
      case RoutesNames.account:
        return MaterialPageRoute(builder: (_) => const AccountPage());
      case RoutesNames.atests:
        return MaterialPageRoute(builder: (_) => const AtestsPage());
      case RoutesNames.archive:
        return MaterialPageRoute(builder: (_) => const ArchivePage());
      case RoutesNames.team:
        return MaterialPageRoute(builder: (_) => const TeamPage());
      case RoutesNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
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

  Future<T?> push<T extends Object?>(String route, {Object? arguments}) async {
    return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  Future<T?> replace<T extends Object?>(String route) async {
    return navigatorKey.currentState?.pushReplacementNamed(route);
  }

  Future<T?> pushAndRemove<T extends Object?>(String route, {bool Function(Route<dynamic>)? predicate}) async {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      predicate ?? ModalRoute.withName('/'),
    );
  }
}
