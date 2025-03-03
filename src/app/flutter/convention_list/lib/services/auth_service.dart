import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:convention_list/util/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../util/permissions.dart';

@lazySingleton
class AuthService {
  Credentials? credentials;
  final List<String> permissions = [];
  final _auth0 = Auth0(auth0Domain, auth0ClientId);

  Future<Credentials?> login() async {
    Credentials creds = await _auth0.webAuthentication(scheme: 'app').login(audience: 'https://api.conventionlist.org');
    credentials = creds;
    var decodedToken = JwtDecoder.decode(creds.accessToken);
    for (var p in decodedToken['permissions']) {
      permissions.add(p);
    }
    return credentials;
  }

  bool get isAdmin => permissions.contains(Permissions.manageAllConventions);

  Future<void> logout() async {
    await _auth0.webAuthentication(scheme: 'app').logout();
    credentials = null;
  }
}
