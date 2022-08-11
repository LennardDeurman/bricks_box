import 'dart:io';
import 'builder/builder.dart';
import 'builder/dto_builder.dart';
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
      print('Found .models file ${item.path}');

      final config = await loadYamlToMap(item.path);
      final modelBuilder = ModelBuilder(config);
      final forcedDelete = config.get<bool>(BrickArguments.forcedDelete, false);
      if (forcedDelete || destructAllFiles) {
        toBeDeletedEntities.add(item);
      }

      futures.add(modelBuilder.run());
    } else if (item.path.endsWith(Constants.dtoEnding)) {
      print('Found .dto file ${item.path}');

      final config = await loadYamlToMap(item.path);
      final dtoBuilder = DtoBuilder(config);
      final forcedDelete = config.get<bool>(BrickArguments.forcedDelete, false);
      if (forcedDelete || destructAllFiles) {
        toBeDeletedEntities.add(item);
      }

      futures.add(dtoBuilder.run());
    }
  }

  await Future.wait(futures).then((_) async {
    final deleteFutures = toBeDeletedEntities.map((e) => e.delete());
    await Future.wait(deleteFutures);

    await Process.run(
      'dart',
      ['format', '.'],
      runInShell: true,
    );

    await Process.run(
      'flutter',
      ['packages' 'pub' 'run' 'build_runner' 'build' '--delete-conflicting-outputs'],
      runInShell: true,
    );
  });
}
