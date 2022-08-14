import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../bin/constants/brick_arguments.dart';

void main() {
  const _importsKey = 'imports';
  const _codeLinesKey = 'code_lines';
  const _mapperGeneratorFileName = 'mapper_generator.dart';
  const _outputFileName = 'output.json';

  /// Loads the yaml from a specified file path
  Future<Map> loadYamlToMap(String filePath) async {
    final contents = await File(filePath).readAsString();
    YamlMap doc = loadYaml(contents);
    return doc.value;
  }

  /// Loads the map structure into a structure of original_class => [output_class] ARRAY
  List<MapEntry<String, List<String>>> yamlMapToConversionEntries(
      Map response) {
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
  List<MapEntry<String, String>> stripEntriesToSingleConversionPairs(
      List<MapEntry<String, List<String>>> entries) {
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
    return "map['${classA.snakeCase}:${classB.snakeCase}'] = _mk(${classA.pascalCase}, ${classB.pascalCase});";
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
    expect(
        classes,
        containsAll([
          'contact_info_entity',
          'contact_info_dto',
          'address_entity',
          'address_dto'
        ]));
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

    final generator = await MasonGenerator.fromBrick(Brick.git(
      GitPath(
        'https://github.com/LennardDeurman/bricks_box',
        path: 'easy_components/templates/mapper_generator',
      ),
    ));

    final target = DirectoryGeneratorTarget(Directory.current);

    await generator.generate(target, vars: {
      _codeLinesKey: codeLines,
      _importsKey: importLines,
    });

    await Process.run(
      'dart',
      ['format', '.'],
      runInShell: true,
    );

    await Process.run('dart', [_mapperGeneratorFileName]);

    final jsonFile = File(_outputFileName);
    final jsonResponse =
        jsonDecode(await jsonFile.readAsString()) as Map<String, dynamic>;

    List<Future> futures = [];

    final map = Map.fromEntries(entries);
    final classes = map.keys.toList() + map.values.expand((x) => x).toList();

    for (MapEntry<String, List<String>> entry in entries) {
      final outputClasses = entry.value;
      List<String> codeBlocks = [];

      String customClassImport = '';

      for (String outputClass in outputClasses) {
        final conversionClass = outputClass.pascalCase;
        final conversionKey =
            '${entry.key.snakeCase}:${conversionClass.snakeCase}';
        final body = jsonResponse[conversionKey]['output'];
        final unknownTypes =
            jsonResponse[conversionKey]['unknown_types'] as List;
        final code =
            "$conversionClass to$conversionClass() {\nreturn $conversionClass($body);\n}";

        final importClasses =
            unknownTypes.where((element) => classes.contains(element));
        customClassImport = importClasses
            .map((importClass) =>
                "import '${importClass.toString().snakeCase}_mapper.dart';")
            .join("\n");

        codeBlocks.add(code);
      }
      final mapperName = '${entry.key.pascalCase}Mapper';
      final mapperContents =
          '$importLines\n\n$customClassImport\n\nextension $mapperName on ${entry.key.pascalCase} {\n\n${codeBlocks.join("\n\n")}\n\n}';
      final mapperFileName = '${mapperName.snakeCase}.dart';
      futures.add(File(mapperFileName).writeAsString(mapperContents));
    }

    await Future.wait(futures);

    await Process.run(
      'dart',
      ['format', '.'],
      runInShell: true,
    );

    await Future.wait([
      File(_mapperGeneratorFileName).delete(),
      jsonFile.delete(),
    ]);
  });
}
