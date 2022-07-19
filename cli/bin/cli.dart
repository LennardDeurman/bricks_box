import 'dart:io';
import 'builder/builder.dart';
import 'builder/model_builder.dart';
import 'map_extension.dart';
import 'constants/brick_arguments.dart';
import 'constants/global.dart';
import 'yaml_loader.dart';

void main(List<String> arguments) async {
  final dir = Directory.current;
  final items = await dir.list().toList();

  bool destructAllFiles = arguments.contains(Constants.withClean);

  List<Future> futures = [];

  List<FileSystemEntity> toBeDeletedEntities = [];


  for (FileSystemEntity item in items) {
    if (item.path.endsWith(Constants.modelsEnding)) {
      final config = await loadYamlToMap(item.path);
      final modelBuilder = ModelBuilder(config);
      final forcedDelete = config.get<bool>(BrickArguments.forcedDelete, false);
      if (forcedDelete || destructAllFiles) {
        toBeDeletedEntities.add(item);
      }

      futures.add(modelBuilder.run());
    }
  }

  await Future.wait(futures).then((_) async {
    final deleteFutures = toBeDeletedEntities.map((e) => e.delete());
    await Future.wait(deleteFutures);
  });
}

