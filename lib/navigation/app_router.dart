import 'package:flutter/material.dart';
import 'package:librum/models/book_manager.dart';
import 'package:librum/navigation/librum_pages.dart';
import 'package:librum/ui/home.dart';
import 'package:librum/ui/login_screen.dart';
import 'package:librum/ui/spalsh_screen.dart';

import '../models/models.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final BookManager bookManager;

  AppRouter({
    required this.appStateManager,
    required this.bookManager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    bookManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    bookManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized && !appStateManager.isLoggedIn)
          LoginScreen.page(),
        if (appStateManager.isLoggedIn) Home.page(),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    if (route.settings.name == LibrumPages.bookDetails) {
      bookManager.bookTapped(-1);
    }

    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
