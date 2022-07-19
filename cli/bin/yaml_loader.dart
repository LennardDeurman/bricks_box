import 'dart:io';

import 'package:yaml/yaml.dart';

Future<Map<String, dynamic>> loadYamlToMap(String filePath) async {
  final contents = await File(filePath).readAsString();
  return loadYaml(contents);
}