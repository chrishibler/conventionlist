import 'package:auth0_flutter/auth0_flutter.dart';

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  static Credentials? credentials;
  final _auth0 = Auth0('hiblermedia.us.auth0.com', 'Jc7oekVuHsEVL1ZvdCiCEy5Uui4NSrPz');

  AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  Future<Credentials?> login() async {
    credentials = await _auth0.webAuthentication().login();
    return credentials;
  }

  Future<void> logout() {
    return _auth0.webAuthentication().logout();
    credentials = null;
  }
}
