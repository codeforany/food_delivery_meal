
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
    locator.registerLazySingleton(() => NavigationService() );
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo (String routeName) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic>? navigatePush(Route route) {
    return navigatorKey.currentState
        ?.push(route);
  }

  void goBack(){
    return navigatorKey.currentState?.pop();
  }
}