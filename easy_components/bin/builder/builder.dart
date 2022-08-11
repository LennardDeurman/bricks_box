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

  Map<String, dynamic> toInputMap(String modelName, YamlMap yamlMap);

  Future<void> run() async {
    final generator = await MasonGenerator.fromBrick(Brick.git(
      GitPath(
        'https://github.com/LennardDeurman/bricks_box',
        path: 'easy_components/$brickPath',
      ),
    ));
    final target = DirectoryGeneratorTarget(Directory.current);

    List<Future<void>> items = [];

    final classNames = config.keys.map((e) => e.toString().pascalCase).toList();
    final suffix = config.get(BrickArguments.suffix, '');

    for (String modelName in config.keys) {
      if ([BrickArguments.suffix].contains(modelName)) return;

      final subMap = config[modelName] as YamlMap;

      final completeModelName = '$modelName$suffix'; //We need to add the suffix here

      final props = subMap[BrickArguments.props] as YamlMap;
      Set<String> importedClasses = {};

      for (var entry in props.entries) {
        final typeDefinition = entry.value as String;

        for (String className in classNames) {
          final exists = typeDefinition.contains(className);
          final completeClassName = '$className$suffix'.pascalCase; //Here suffix as well
          if (exists) importedClasses.add(completeClassName);
          typeDefinition.replaceAll(className, completeClassName);
        }
      }

      final inputMap = toInputMap(completeModelName, subMap);

      //No suffix needed since it was already handled
      inputMap[BrickArguments.imports] =
          importedClasses.map((className) => "import '${className.snakeCase}.dart';").join('\n');

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
