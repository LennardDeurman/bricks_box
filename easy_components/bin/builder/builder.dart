import 'dart:collection';
import 'dart:io';

import 'package:recase/recase.dart';
import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

import '../constants/brick_arguments.dart';
import '../map_extension.dart';

abstract class Builder {
  final String brickPath;
  final Map<dynamic, dynamic> config;

  Builder({
    required this.config,
    required this.brickPath,
  });

  Map<String, dynamic> toInputMap(String modelName, HashMap yamlMap);

  Future<void> run() async {
    final generator = await MasonGenerator.fromBrick(Brick.git(
      GitPath(
        'https://github.com/LennardDeurman/bricks_box',
        path: 'easy_components/$brickPath',
      ),
    ));
    final target = DirectoryGeneratorTarget(Directory.current);

    final suffix = config.get(BrickArguments.suffix, '');

    List<Future<void>> items = [];

    final classNames = config.keys.map((e) => e.toString().pascalCase).toList();

    final modelsMap = HashMap.of(config)
      ..removeWhere((key, _) {
        return [
          BrickArguments.forcedDelete,
          BrickArguments.suffix,
        ].contains(key.toString());
      });

    for (String modelName in modelsMap.keys) {
      final subMap = modelsMap[modelName] as YamlMap;

      final completeModelName =
          '$modelName$suffix'.pascalCase; //We need to add the suffix here

      final props = subMap[BrickArguments.props] as YamlMap;
      Set<String> importedClasses = {};

      final updatedProps = HashMap<String, String>();

      for (var entry in props.entries) {
        var typeDefinition = entry.value as String;

        for (String className in classNames) {
          final exists = typeDefinition.contains(className);
          final completeClassName =
              '$className$suffix'.pascalCase; //Here suffix as well
          if (exists) importedClasses.add(completeClassName);
          typeDefinition =
              typeDefinition.replaceAll(className, completeClassName);
        }

        updatedProps[entry.key] = typeDefinition;
      }

      final updatedSubMap = HashMap.of(subMap);
      updatedSubMap[BrickArguments.props] = updatedProps;

      final inputMap = toInputMap(completeModelName, updatedSubMap);

      //No suffix needed since it was already handled
      inputMap[BrickArguments.imports] = importedClasses
          .map((className) => "import '${className.snakeCase}.dart';")
          .join('\n');

      items.add(
        generator.generate(
          target,
          vars: inputMap,
        ),
      );
    }

    await Future.wait(items);
  }
}
