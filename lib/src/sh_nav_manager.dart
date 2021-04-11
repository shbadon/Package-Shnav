import 'dart:async';
import 'dart:collection';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shnav/src/sh_nav_list_holder.dart';
import 'package:shnav/src/sh_nav_page.dart';
import 'package:shnav/src/sh_nav_page_model.dart';
import 'package:shnav/src/sh_nav_path_model.dart';

class ShNavManager extends ChangeNotifier {
  final List<NavPageModel> allPages;
  final NavPage notFoundPage;
  final Function(Uri)? navNotifier;

  final List<PathModel> initializePathList = [];
  final initializeTitleList = [];
  final initializeUriList = [];
  final initializePageList = [];

  ShNavManager(
      {required this.allPages, required this.notFoundPage, this.navNotifier}) {
    /// this for loop work for divided allPage list
    for (int i = 0; i < allPages.length; i++) {
      final path = allPages[i].path;
      final page = allPages[i].page;
      final title = allPages[i].title;
      initializePathList.add(PathModel(path));
      initializeTitleList.add(title);
      initializePageList.add(page);
    }
  }

  /// this two from ListHolder page.
  final _pages = ListHolder().createState().pagesList;
  final _uris = ListHolder().createState().urisList;
  // final _pages = <Page>[];
  // final _uris = <Uri>[];

  /// this two list call from ShNavDelegate
  List<Page> get pages => UnmodifiableListView(_pages);
  List<Uri> get uris => UnmodifiableListView(_uris);

  late Completer<dynamic> _boolResultCompleter;

  /// here is main function
  /// this Function control page
  Future<void> _setNewRoutePath(
      Uri uri, dynamic params, bool sentNotFoundPage) {
    bool _findRoute = false;
    setNavNotifier(uri);
    if (!sentNotFoundPage) {
      /// here set all page
      for (int i = 0; i < initializePathList.length; i++) {
        final path = initializePathList[i].path;
        if (path == uri.path) {
          // if (_uris.contains(uri)) {
          //   final position = _uris.indexOf(uri);
          //   final _urisLength = _uris.length;
          //   for (var start = position; start < _urisLength - 1; start++) {
          //     _pages.removeLast();
          //     _uris.removeLast();
          //   }
          //   _findRoute = true;
          //   break;
          // }

          final page = initializePageList[i];
          page.setFunction(uri, params);
          _pages.add(page);
          _uris.add(uri);
          setTitle(uri, false);
          _findRoute = true;
          break;
        }
      }
    }

    /// set not found page here
    if (!_findRoute || sentNotFoundPage) {
      final page = notFoundPage;
      page.setFunction(uri, params);
      _pages.add(page);
      _uris.add(uri);
      setTitle(uri, true);
    }

    notifyListeners();
    return SynchronousFuture(null);
  }

  /// use:- context.shNav.push(Uri(path:'/books'));
  /// if you want add params :- context.shNav.push(Uri(path:'/books'),params:'data');
  ///  get data :-  screen: (path, params) {
  //                  return BooksScreen(
  //                   data:params ,
  //                    );
  //                  }

  Future<void> push(Uri uri, {dynamic params}) =>
      _setNewRoutePath(uri, params, false);

  /// [pushWithQueryPara] work for navigate and send some dynamic data.
  /// use:- context.shNav.pushWithQueryPara('/books', {'id':'1'});
  /// get data :-  screen: (path, params) {
  //                 final id = path.queryParameters['id'];
  //                 return BooksScreen(
  //                   id: id == null ? 'null' : id.toString(),
  //                 );
  //               }

  Future<void> pushWithQueryPara(String path, dynamic para, {dynamic params}) =>
      _setNewRoutePath(Uri(path: path, queryParameters: para), params, false);

  Future<void> sendNotFoundPage(Uri uri, {dynamic params}) =>
      _setNewRoutePath(uri, params, true);

  ///pop
  void pop() {
    if (_pages.length > 1) {
      removeLastUri();
    } else {
      print('Cannot pop');
    }
  }

  /// [setTitle] work for set Page Title
  void setTitle(Uri uri, bool unknown) {
    if (!unknown) {
      for (int i = 0; i < initializePathList.length; i++) {
        final path = initializePathList[i].path;
        if (path == uri.path) {
          SystemChrome.setApplicationSwitcherDescription(
            ApplicationSwitcherDescription(
              label: initializeTitleList[i],
              primaryColor: Colors.blueAccent.value,
            ),
          );
          break;
        }
      }
    } else {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: 'Unknown',
          primaryColor: Colors.blueAccent.value,
        ),
      );
    }
  }

  /// replace
  Future<void> replace(Uri uri, {dynamic params}) {
    _pages.removeAt(_pages.length - 1);
    _uris.removeAt(_uris.length - 1);
    return _setNewRoutePath(uri, params, false);
  }

  /// clear the list of [pages] and then push an [Uri]
  Future<void> clearAndPush(Uri uri, {dynamic params}) {
    _pages.clear();
    _uris.clear();
    return push(uri, params: params);
  }

  /// Push multiple [Uri] at once
  Future<void> pushAll(List<Uri> uris, {required List<dynamic> params}) async {
    int index = 0;
    for (final uri in uris) {
      if (params is List) {
        await push(uri, params: params[index]);
      } else {
        await push(uri);
      }
      index++;
    }
  }

  /// clear the list of [pages] and then push multiple [Uri] at once
  Future<void> clearAndPushAll(List<Uri> uris,
      {required List<dynamic> params}) {
    _pages.clear();
    _uris.clear();
    return pushAll(uris, params: params);
  }

  /// remove a specific Uri and the corresponding Page
  void removeUri(Uri uri) {
    final index = _uris.indexOf(uri);
    _pages.removeAt(index);
    _uris.removeAt(index);
    notifyListeners();
  }

  /// remove the last Uri and the corresponding Page
  void removeLastUri() {
    _pages.removeLast();
    _uris.removeLast();
    notifyListeners();
  }

  /// Simple method to use instead of `await Navigator.push(context, ...)`
  /// The result can be set either by [returnWith]
  Future<dynamic> waitAndPush(Uri uri, {dynamic params}) async {
    _boolResultCompleter = Completer<dynamic>();
    await push(uri, params: params);
    notifyListeners();
    return _boolResultCompleter.future;
  }

  /// remove the pages and go root page
  void popToRoot() {
    _pages.removeRange(1, _pages.length);
    _uris.removeRange(1, _uris.length);
    notifyListeners();
  }

  /// it work when using [navNotifier]
  void setNavNotifier(Uri uri) {
    if (navNotifier != null) {
      navNotifier!(uri);
    }
  }
}
