import 'dart:io';

import 'package:yaml/yaml.dart';

Future<Map> loadYamlToMap(String filePath) async {
  final contents = await File(filePath).readAsString();
  YamlMap doc = loadYaml(contents);
  return doc.value;
}