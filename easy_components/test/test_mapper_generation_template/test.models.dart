/// Corresponding test files for mapper_generation_test.dart

class MirrorTestChild {
  final String id;
  const MirrorTestChild({required this.id});
}

class MirrorTestChildEntity {
  final String id;
  const MirrorTestChildEntity({required this.id});
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
