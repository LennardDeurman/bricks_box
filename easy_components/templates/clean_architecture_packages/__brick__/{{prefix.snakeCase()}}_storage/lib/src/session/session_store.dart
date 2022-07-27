import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

import 'session_entity.dart';

class SessionStore {
  static const _version = 1;
  static const _sessionKey = 'session';

  final FlutterSecureStorage _storage;

  final _session = BehaviorSubject<SessionEntity?>();

  SessionStore(this._storage) {
    getSession().then(
      _session.add,
      onError: (_, __) => _session.add(null),
    );
  }

  Future<SessionEntity?> getSession() async {
    if (_session.hasValue && _session.value != null) return _session.value;
    final sessionJson = await _storage.read(key: _sessionKey);
    if (sessionJson == null) return null;
    return SessionEntity.fromJson(json.decode(sessionJson));
  }

  Future<void> storeSession(SessionEntity session) async {
    final sessionWithVersion = session.copyWith(version: _version);
    final sessionJson = json.encode(sessionWithVersion.toJson());
    await _storage.write(key: _sessionKey, value: sessionJson);
    _session.add(session);
  }

  Stream<SessionEntity?> observeSession() => _session.stream;

  Future<void> clearSession() async {
    _session.add(null);
    await _storage.delete(key: _sessionKey);
  }
}
