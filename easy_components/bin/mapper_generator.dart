import 'dart:convert';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:recase/recase.dart';
import 'package:yaml/yaml.dart';

import 'constants/brick_arguments.dart';
import 'map_extension.dart';

class MapperConfig {
  late final List<String> imports;
  late final String exportFile;
  late final bool autoGenerateImports;
  late final Map objectsMap;

  MapperConfig(Map response) {
    imports = response.get<List>(BrickArguments.imports, []).map((e) => e.toString()).toList();
    exportFile = response.get(BrickArguments.genExport, '');
    autoGenerateImports = response.get<bool>(BrickArguments.autoGenerateImports, true);
    objectsMap = Map.from(response)
      ..removeWhere(
        (key, value) => [
          BrickArguments.imports,
          BrickArguments.genExport,
          BrickArguments.autoGenerateImports,
        ].contains(key),
      );
  }
}

class MapperGenerator {
  final MapperConfig _config;

  late final List<MapEntry<String, List<String>>> _conversionEntries;
  late final List<MapEntry<String, String>> _singleConversionEntries;
  late final String _importLines;
  late final Set<String> _classes;

  static const _mapperGeneratorFileName = 'mapper_generator.dart';
  static const _outputFileName = 'output.json';

  static const _dartCodeGeneratorGitPath = GitPath(
    'https://github.com/LennardDeurman/bricks_box',
    path: 'easy_components/templates/mapper_generator',
  );

  MapperGenerator(Map yaml) : _config = MapperConfig(yaml) {
    _conversionEntries = yamlMapToConversionEntries(_config.objectsMap);
    _singleConversionEntries = stripEntriesToSingleConversionPairs(_conversionEntries);
    _importLines = generateImportLines(_config.imports); //The imports defined in the yaml file
    _classes = parseClasses(_conversionEntries);
  }

  /// Clears the build files
  Future<void> clearBuildFiles() async {
    await Future.wait([
      File(_outputFileName).delete(),
      File(_mapperGeneratorFileName).delete(),
    ]);
  }

  /// Run the procedure
  Future<void> run() async {
    await makeDartJsonGenerationCode();
    await loadClassStructureAndWriteOutputs();
    await clearBuildFiles();
  }

  /// Parses the classes in the original input case as used in the yaml config
  Set<String> parseClasses(List<MapEntry<String, List<String>>> entries) {
    final map = Map.fromEntries(entries);
    return Set<String>.from(map.keys.toList() + map.values.expand((x) => x).toList());
  }

  /// Generates the imports lines
  String generateImportLines(List<String> imports) {
    final buffer = StringBuffer();

    for (final import in imports) {
      buffer.writeln("import '$import';");
    }

    return buffer.toString();
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

  /// Writes a dart file, that creates the constructor bodies as json strings
  Future<void> makeDartJsonGenerationCode() async {
    final generator = await MasonGenerator.fromBrick(Brick.git(_dartCodeGeneratorGitPath));

    final target = DirectoryGeneratorTarget(Directory.current);

    await generator.generate(target, vars: {
      BrickArguments.codeLines: generateCodeLines(_singleConversionEntries),
      BrickArguments.imports: _importLines,
    });

    await Process.run(
      'dart',
      ['format', '.'],
      runInShell: true,
    );

    await Process.run('dart', [_mapperGeneratorFileName]);
  }

  /// Create the mapper file
  Future<void> createMapperFile({
    required String className,
    required String customClassImport,
    required List<String> codeBlocks,
  }) {
    final mapperName = '${className.pascalCase}Mapper';
    final mapperContents =
        '$_importLines\n\n$customClassImport\n\nextension $mapperName on ${className.pascalCase} {\n\n${codeBlocks.join("\n\n")}\n\n}';
    final mapperFileName = '${mapperName.snakeCase}.dart';
    return File(mapperFileName).writeAsString(mapperContents);
  }

  /// Make an export file based on the classes used
  Future<void> generateExportFile() {
    return File('${_config.exportFile.snakeCase}.dart').writeAsString(generateExportContents(_classes));
  }

  /// Generates the content for to exports
  String generateExportContents(Set<String> classes) {
    return classes.map((className) => "export '${className.snakeCase}_mapper.dart';").join('\n');
  }

  /// Creates a mapper code block
  String createMapperCodeBlock({
    required String conversionClass,
    required String body,
  }) {
    return "$conversionClass to$conversionClass() {\nreturn $conversionClass($body);\n}";
  }

  /// Makes custom class imports
  String createCustomClassImports(List unknownTypes, Set<String> classes) {
    final importClasses = unknownTypes.where((element) => classes.contains(element));
    return Set.from(importClasses)
        .map((importClass) => "import '${importClass.toString().snakeCase}_mapper.dart';")
        .join("\n");
  }

  /// Read the created json file and write the mappers
  Future<void> loadClassStructureAndWriteOutputs() async {
    final jsonFile = File(_outputFileName);
    final jsonResponse = jsonDecode(await jsonFile.readAsString()) as Map<String, dynamic>;

    List<Future> futures = [];

    for (MapEntry<String, List<String>> entry in _conversionEntries) {
      final outputClasses = entry.value;
      List<String> codeBlocks = [];

      String customClassImport = '';

      for (String outputClass in outputClasses) {
        final conversionClass = outputClass.pascalCase;
        final conversionKey = '${entry.key.snakeCase}:${conversionClass.snakeCase}';
        final body = jsonResponse[conversionKey]['output'];
        codeBlocks.add(createMapperCodeBlock(conversionClass: conversionClass, body: body));

        if (_config.autoGenerateImports) {
          // If the parser encounters an unknown type, then try to resolve it
          final unknownTypes = jsonResponse[conversionKey]['unknown_types'] as List;
          customClassImport = createCustomClassImports(unknownTypes, _classes);
        }
      }

      futures.add(
        createMapperFile(
          className: entry.key,
          customClassImport: customClassImport,
          codeBlocks: codeBlocks,
        ),
      );
    }

    if (_config.exportFile.isNotEmpty) {
      futures.add(generateExportFile());
    }
  }
}
