import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'sh_nav_helper.dart';

/// Select Page type.
///default anim page type "material".
enum NavPageType {
  material,
  cupertino,
  noTransition,
  fadeTransition,
}

class NavPage extends Page {
  /// PageBuilder [typedef PageBuilder = Widget Function(Uri path, dynamic params);]
  /// use:-   screen: (Uri path, params) {
  //           return Scaffold(
  //             body: Container(
  //             ),
  //           );
  //         }
  final PageBuilder screen;

  /// [NavPageType]
  // use:- pageType: NavPageType.fadeTransition,
  final NavPageType pageType;

  NavPage({
    this.pageType = NavPageType.material,

    /// use:- key: ValueKey('****'),
    required LocalKey key,
    required this.screen,
  });

  /// full Code :-  NavPage(
  //               key: ValueKey('home'),
  //               pageType: NavPageType.fadeTransition,
  //               screen: (Uri path, params) => HomeScreen())

  /// [setFunction] work for set screen (path,params)
  /// It gives current Uri, Params
  void setFunction(Uri path, dynamic params) {
    /// [initializePath] and [initializeParams]
    /// They are come 'sh_nav_helper.dart' page
    /// default value initializePath = '/',initializeParams = null
    initializePath = path;
    initializeParams = params;
  }

  @override
  Route createRoute(BuildContext context) {
    switch (pageType) {
      case NavPageType.material:
        return MaterialPageRoute(
          settings: this,
          builder: (context) => child(),
        );
      case NavPageType.cupertino:
        return CupertinoPageRoute(
          settings: this,
          builder: (context) => child(),
        );
      case NavPageType.noTransition:
        return PageRouteBuilder(
          settings: this,
          pageBuilder: (context, animation, secondaryAnimation) => child(),
        );
      case NavPageType.fadeTransition:
        return PageRouteBuilder(
          settings: this,
          pageBuilder: (_, __, ___) => child(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      default:
        return MaterialPageRoute(
          settings: this,
          builder: (context) => child(),
        );
    }
  }

  Widget child() {
    return screen(initializePath, initializeParams);
  }
}
