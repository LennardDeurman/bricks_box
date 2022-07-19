import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

abstract class Builder {
  final String brickPath;
  final Map<dynamic, dynamic> config;

  Builder({
    required this.config,
    required this.brickPath,
  });

  Map<String, dynamic> toInputMap(String modelName, YamlMap yamlMap);

  Future<void> run() async {
    final brick = Brick.path(brickPath);
    final generator = await MasonGenerator.fromBrick(brick);
    final target = DirectoryGeneratorTarget(Directory.current);


    List<Future<void>> items = [];

    for (String modelName in config.keys) {
      final subMap = config[modelName] as YamlMap;
      final inputMap = toInputMap(modelName, subMap);
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