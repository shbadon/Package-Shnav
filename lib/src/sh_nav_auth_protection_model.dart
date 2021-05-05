
enum Protection{
  on,off
}
class AuthProtection {
  final Protection protection;
  final String authPagePath;
  final bool authentication;
 const AuthProtection({this.protection = Protection.off ,this.authPagePath = '/' , this.authentication = false});

  String get getAuthPagePath => authPagePath ;
  bool get getAuthentication => authentication;
  Protection get getProtection => protection;
}
