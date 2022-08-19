import 'dart:convert';
import 'package:test/test.dart';

import '../../bin/objects_mapper/data_verification_generator.dart';
import '../../bin/objects_mapper/mapper_generator.dart';
import '../../bin/yaml_loader.dart';
import 'mocks.dart';

void main() {
  group('Test creation of the mapper classes', () {
    test('Test yaml loader', () async {
      final config = await loadYamlToMap('test.mappers.yaml');
      expect(config, isNotNull);
    });

    test('Initialize mapper generator', () async {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final conversionEntries = mapperGenerator.yamlMapToConversionEntries(mockObjectsMap);
      final outputMap = Map.fromEntries(conversionEntries);

      for (final inputEntry in mockEntries) {
        expect(
          conversionEntries,
          containsAll(
            mockEntries.map(
              (e) => TypeMatcher<MapEntry>().having((entry) => entry.key, 'key', e.key)
                ..having(
                  (entry) => e.value,
                  'value',
                  inputEntry.value,
                ),
            ),
          ),
        );
      }

      expect(
        outputMap.keys,
        ['mirror_test', 'mirror_test_child', 'mirror_test_entity', 'mirror_test_child_entity'],
      );
      expect(outputMap.values, [
        ['mirror_test_entity'],
        ['mirror_test_child_entity'],
        ['mirror_test'],
        ['mirror_test_child'],
      ]);
    });

    test('Generate import lines', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final imports = mapperGenerator.generateImportLines(['mirror_test', 'mirror_test_child']);
      expect(imports, "import 'mirror_test';\nimport 'mirror_test_child';\n");
    });

    test('Parse classes', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final classes = mapperGenerator.parseClasses(mockEntries);
      expect(classes, ['mirror_test', 'mirror_test_child', 'mirror_test_entity', 'mirror_test_child_entity']);
    });

    //Generate code lines
    test('Generate code lines', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final codeLines = mapperGenerator.generateCodeLines(mockSingleEntries);
      expect(
        codeLines,
        "map['mirror_test:mirror_test_entity'] = _mk(MirrorTest, MirrorTestEntity, classContents,);\n"
        "map['mirror_test_child:mirror_test_child_entity'] = _mk(MirrorTestChild, MirrorTestChildEntity, classContents,);\n"
        "map['mirror_test_entity:mirror_test'] = _mk(MirrorTestEntity, MirrorTest, classContents,);\n"
        "map['mirror_test_child_entity:mirror_test_child'] = _mk(MirrorTestChildEntity, MirrorTestChild, classContents,);\n",
      );
    });

    test('Generate export contents', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final imports = mapperGenerator.generateExportContents({'mirror_test', 'mirror_test_entity'});
      expect(
        imports,
        "export 'mirror_test_mapper.dart';\n"
        "export 'mirror_test_entity_mapper.dart';",
      );
    });

    test('Create mapper code block', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final res = mapperGenerator.createMapperCodeBlock(conversionClass: 'Mirror', body: 'id: id');
      expect(res, 'Mirror toMirror() {\nreturn Mirror(id: id);\n}');
    });

    test('Create custom import classes', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final customImport =
          mapperGenerator.createCustomClassImports(['mirror_test_child', 'mirror_test'], {'mirror_test'});
      expect(customImport, "import 'mirror_test_mapper.dart';");
    });

    test('Convert to single pair', () {
      final mapperGenerator = MapperGenerator(mockConfigMap);
      final singleEntries = mapperGenerator.stripEntriesToSingleConversionPairs(mockEntries);

      for (final inputEntry in mockSingleEntries) {
        expect(
          singleEntries,
          containsAll(
            mockSingleEntries.map(
              (e) => TypeMatcher<MapEntry>().having((entry) => entry.key, 'key', e.key)
                ..having(
                  (entry) => e.value,
                  'value',
                  inputEntry.value,
                ),
            ),
          ),
        );
      }
    });
  });
}
