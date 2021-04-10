import 'package:flutter/material.dart';
import 'package:shnav/src/sh_nav_manager.dart';
import 'package:shnav/src/sh_nav_page.dart';
import 'package:shnav/src/sh_nav_page_model.dart';

class ShNavDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Uri> {
    final NavPage notFoundPage;
  final List<NavPageModel> pages;
  final Function(Uri)? navNotifier;

  late ShNavManager routeManager;
  static ShNavManager of(BuildContext context) {
    return (Router.of(context).routerDelegate as ShNavDelegate).routeManager;
  }

  ShNavDelegate(
      {required this.notFoundPage, required this.pages, this.navNotifier}) {
    routeManager = ShNavManager(
        allPages: pages, notFoundPage: notFoundPage, navNotifier: navNotifier);
    routeManager.addListener(notifyListeners);
    // ignore: prefer_foreach
    for (final uri in [Uri(path: '/')]) {
      routeManager.push(uri);
    }
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Uri? get currentConfiguration =>
      routeManager.uris.isNotEmpty ? routeManager.uris.last : null;

  @override
  Future<void> setNewRoutePath(Uri uri) => routeManager.push(uri);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        for (final page in routeManager.pages) page,
      ],
      transitionDelegate: DefaultTransitionDelegate(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (routeManager.initializePageList.isNotEmpty) {
          routeManager.removeLastUri();
          return true;
        }
        return false;
      },
      observers: [HeroController()],
    );
  }
}
