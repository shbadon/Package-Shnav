import 'package:shnav/src/sh_nav_auth_protection_model.dart';
import 'package:shnav/src/sh_nav_page.dart';

class ShNavPage {
  final String path;
  final String title;
  final NavPage page;
  final AuthProtection protection;

  ShNavPage(
      {required this.path,
      required this.title,
      this.protection = const AuthProtection(),
      required this.page});

}
