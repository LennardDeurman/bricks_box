import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_entity.g.dart';

@JsonSerializable()
@CopyWith()
class SessionEntity {
  final int version;
  final String accessToken;

  SessionEntity({
    this.version = 1,
    required this.accessToken,
  });

  factory SessionEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SessionEntityToJson(this);
}
