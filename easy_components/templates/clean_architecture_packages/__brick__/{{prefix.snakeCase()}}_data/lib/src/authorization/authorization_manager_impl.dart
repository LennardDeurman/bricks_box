import 'package:cl_api/cl_api.dart';
import 'package:cl_storage/cl_storage.dart';

class AuthorizationManagerImpl implements AuthorizationManager {
  final SessionStore _sessionStore;

  AuthorizationManagerImpl(this._sessionStore);

  @override
  Future<String?> getAccessToken() async {
    final session = await _sessionStore.getSession();
    return session?.accessToken;
  }
}
