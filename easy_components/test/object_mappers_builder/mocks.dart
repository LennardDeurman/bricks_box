import 'dart:convert';

final mockConfigMap = Map.from(jsonDecode(
    '{"imports":["test.models.dart"],"gen_export":"mappers","mirror_test":{"to":"mirror_test_entity"},"mirror_test_child":{"to":"mirror_test_child_entity"},"mirror_test_entity":{"to":"mirror_test"},"mirror_test_child_entity":{"to":"mirror_test_child"}}'));

final mockObjectsMap = Map.from(
  jsonDecode(
    '{"mirror_test":{"to":"mirror_test_entity"},"mirror_test_child":{"to":"mirror_test_child_entity"},"mirror_test_entity":{"to":"mirror_test"},"mirror_test_child_entity":{"to":"mirror_test_child"}}',
  ),
);

final mockEntries = [
  MapEntry('mirror_test', ['mirror_test_entity']),
  MapEntry('mirror_test_child', ['mirror_test_child_entity']),
  MapEntry('mirror_test_entity', ['mirror_test']),
  MapEntry('mirror_test_child_entity', ['mirror_test_child']),
];

final mockSingleEntries = [
  MapEntry('mirror_test', 'mirror_test_entity'),
  MapEntry('mirror_test_child', 'mirror_test_child_entity'),
  MapEntry('mirror_test_entity', 'mirror_test'),
  MapEntry('mirror_test_child_entity', 'mirror_test_child'),
];