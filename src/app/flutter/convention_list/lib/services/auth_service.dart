import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static Credentials? credentials;
  final List<String> permissions = [];
  final _auth0 = Auth0('hiblermedia.us.auth0.com', 'Jc7oekVuHsEVL1ZvdCiCEy5Uui4NSrPz');
  static final AuthService _singleton = AuthService._internal();

  AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  Future<Credentials?> login() async {
    Credentials creds = await _auth0.webAuthentication(scheme: 'app').login(audience: 'https://api.conventionlist.org');
    credentials = creds;
    var decodedToken = JwtDecoder.decode(creds.accessToken);
    for (var p in decodedToken['permissions']) {
      permissions.add(p);
    }
    return credentials;
  }

  Future<void> logout() async {
    await _auth0.webAuthentication(scheme: 'app').logout();
    credentials = null;
  }
}
