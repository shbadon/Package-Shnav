
class PathModel {
  final String path;
  final String authPagePath;
  final bool authProtection;
  final bool authentication;
  PathModel({required this.path,required this.authProtection , required this.authPagePath, required this.authentication});
  String get getPath => path;
}
