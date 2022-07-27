// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SessionEntityCWProxy {
  SessionEntity accessToken(String accessToken);

  SessionEntity version(int version);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionEntity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionEntity call({
    String? accessToken,
    int? version,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSessionEntity.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSessionEntity.copyWith.fieldName(...)`
class _$SessionEntityCWProxyImpl implements _$SessionEntityCWProxy {
  final SessionEntity _value;

  const _$SessionEntityCWProxyImpl(this._value);

  @override
  SessionEntity accessToken(String accessToken) =>
      this(accessToken: accessToken);

  @override
  SessionEntity version(int version) => this(version: version);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SessionEntity(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SessionEntity(...).copyWith(id: 12, name: "My name")
  /// ````
  SessionEntity call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? version = const $CopyWithPlaceholder(),
  }) {
    return SessionEntity(
      accessToken:
          accessToken == const $CopyWithPlaceholder() || accessToken == null
              ? _value.accessToken
              // ignore: cast_nullable_to_non_nullable
              : accessToken as String,
      version: version == const $CopyWithPlaceholder() || version == null
          ? _value.version
          // ignore: cast_nullable_to_non_nullable
          : version as int,
    );
  }
}

extension $SessionEntityCopyWith on SessionEntity {
  /// Returns a callable class that can be used as follows: `instanceOfSessionEntity.copyWith(...)` or like so:`instanceOfSessionEntity.copyWith.fieldName(...)`.
  _$SessionEntityCWProxy get copyWith => _$SessionEntityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionEntity _$SessionEntityFromJson(Map<String, dynamic> json) =>
    SessionEntity(
      version: json['version'] as int? ?? 1,
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$SessionEntityToJson(SessionEntity instance) =>
    <String, dynamic>{
      'version': instance.version,
      'accessToken': instance.accessToken,
    };
