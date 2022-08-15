class MirrorTestChild {
  final String id;
  const MirrorTestChild({required this.id});
}

class MirrorTestChildEntity {
  final String id;
  const MirrorTestChildEntity({required this.id});
}

class MirrorTestChildDto {
  final String id;
  const MirrorTestChildDto({required this.id});
}

class MirrorTestDto {
  final String id;
  final String name;
  final List<String>? items;
  final MirrorTestChildDto child;

  const MirrorTestDto({
    required this.id,
    required this.name,
    required this.child,
    this.items,
  });
}

class MirrorTest {
  final String id;
  final String name;
  final List<String>? items;
  final MirrorTestChild child;
  final List<MirrorTestChild>? children;

  const MirrorTest({
    required this.id,
    required this.name,
    required this.child,
    this.items,
    this.children,
  });
}

class MirrorTestEntity {
  final String id;
  final String name;
  final List<String>? items;
  final MirrorTestChildEntity child;
  final List<MirrorTestChildEntity>? children;

  const MirrorTestEntity({
    required this.id,
    required this.name,
    this.items,
    required this.child,
    this.children,
  });
}
