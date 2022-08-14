import 'dart:io';
import 'dart:mirrors';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../bin/constants/brick_arguments.dart';

void main() {
  const _importsKey = 'imports';

  /// Loads the yaml from a specified file path
  Future<Map> loadYamlToMap(String filePath) async {
    final contents = await File(filePath).readAsString();
    YamlMap doc = loadYaml(contents);
    return doc.value;
  }

  /// Loads the map structure into a structure of original_class => [output_class] ARRAY
  List<MapEntry<String, List<String>>> yamlMapToConversionEntries(Map response) {
    List<MapEntry<String, List<String>>> entries = [];
    for (var mapEntry in response.entries) {
      final result = response[mapEntry.key];
      final to = result[BrickArguments.to] as String;
      final conversionClasses = to.split(',');
      entries.add(MapEntry(mapEntry.key, conversionClasses));
    }
    return entries;
  }

  /// Strips the multidimensional entries to single entries e.g. original_class => output_class [VALUE-VALUE]
  List<MapEntry<String, String>> stripEntriesToSingleConversionPairs(List<MapEntry<String, List<String>>> entries) {
    final conversions = <MapEntry<String, String>>[];
    for (final entry in entries) {
      final outputClasses = entry.value;
      for (String outputClass in outputClasses) {
        conversions.add(MapEntry(entry.key, outputClass));
      }
    }
    return conversions;
  }

  /// Generates a single code line
  String generateCodeLine(String classA, String classB) {
    return "map['${classA.snakeCase}:${classB.snakeCase}'] = _mk(${classA.pascalCase}, ${classB.pascalCase})";
  }

  /// Generates all code line s
  String generateCodeLines(List<MapEntry<String, String>> conversions) {
    final buffer = StringBuffer();

    for (final conversion in conversions) {
      buffer.writeln(generateCodeLine(conversion.key, conversion.value));
    }

    return buffer.toString();
  }

  /// Generates all code line s
  String generateImportLines(YamlList imports) {
    final buffer = StringBuffer();

    for (final import in imports) {
      buffer.writeln("import '$import';");
    }

    return buffer.toString();
  }

  test('Test parsing of mappers structure', () async {
    final response = await loadYamlToMap('example.mappers.yaml');
    final classes = [];
    for (var mapEntry in response.entries) {
      final result = response[mapEntry.key];
      final to = result[BrickArguments.to] as String;
      final conversionClasses = to.split(',');
      classes.addAll(conversionClasses);
    }
    expect(classes, containsAll(['contact_info_entity', 'contact_info_dto', 'address_entity', 'address_dto']));
  });

  test('Test line', () async {
    final codeLine = generateCodeLine('model_entity', 'model');
    expect(codeLine, "map['model_entity:model'] = _mk(ModelEntity, Model)");
  });

  test('Test parsing of mappers structure', () async {
    final response = await loadYamlToMap('test.mappers.yaml');
    final imports = response[_importsKey] as YamlList;

    final configKeys = [_importsKey];

    final entries = yamlMapToConversionEntries(
      Map.from(response)
        ..removeWhere(
          (key, value) => configKeys.contains(key),
        ),
    );

    final conversions = stripEntriesToSingleConversionPairs(entries);

    final codeLines = generateCodeLines(conversions);
    final importLines = generateImportLines(imports);

    expect(
      codeLines,
      "map['mirror_test:mirror_test_entity'] = _mk(MirrorTest, MirrorTestEntity)\nmap['mirror_test_entity:mirror_test'] = _mk(MirrorTestEntity, MirrorTest)\n",
    );

    expect(importLines, "import 'test.models.dart';\n");

    final generator = await MasonGenerator.fromBrick(Brick.git(
      GitPath(
        'https://github.com/LennardDeurman/bricks_box',
        path: 'easy_components/templates/mapper_generator',
      ),
    ));

    final target = DirectoryGeneratorTarget(Directory.current);

    await generator.generate(target, vars: {
      'code_lines': codeLines,
      'imports': importLines,
    });
  });
}
