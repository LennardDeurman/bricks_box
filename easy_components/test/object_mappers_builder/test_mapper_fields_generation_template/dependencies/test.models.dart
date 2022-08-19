/// Corresponding test files for mapper_field_generation_test.dart

import 'package:json_annotation/json_annotation.dart';

part 'test.models.g.dart';

@JsonSerializable()
class MirrorTestChild {
  @JsonKey(name: 'id')
  final String id;
  const MirrorTestChild({required this.id});

  Map<String, dynamic> toJson() => _$MirrorTestChildToJson(this);
}

@JsonSerializable()
class MirrorTestChildEntity {
  @JsonKey(name: 'id')
  final String id;
  const MirrorTestChildEntity({required this.id});

  Map<String, dynamic> toJson() => _$MirrorTestChildEntityToJson(this);
}

class MirrorTest {
  final String id;
  final String name;
  final List<String>? items;
  final List<MirrorTestChild>? children;
  final MirrorTestChild child;

  const MirrorTest({
    required this.id,
    required this.name,
    required this.child,
    this.children,
    this.items,
  });
}

class MirrorTestEntity {
  final String id;
  final String name;
  final List<String>? items;
  final List<MirrorTestChild>? children;
  final MirrorTestChildEntity child;

  const MirrorTestEntity({
    required this.id,
    required this.name,
    this.items,
    this.children,
    required this.child,
  });
}
