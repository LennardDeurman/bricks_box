import 'package:yaml/yaml.dart';

import '../constants/brick_arguments.dart';
import '../constants/global.dart';
import '../map_extension.dart';
import '../query_converter.dart';
import 'builder.dart';
import 'package:pre_hooks/pre_hooks.dart';

class DtoBuilder extends Builder {
  DtoBuilder(Map<dynamic, dynamic> config)
      : super(config: config, brickPath: Constants.brickDtoLocation);

  @override
  Map<String, dynamic> toInputMap(String modelName, YamlMap yamlMap) {
    final fromJson = yamlMap.get<bool>(BrickArguments.fromJson, true);
    final toJson = yamlMap.get<bool>(BrickArguments.toJson, true);

    final props = yamlMap[BrickArguments.props] as YamlMap;

    return DtoInputConverter({
      BrickArguments.name: modelName,
      BrickArguments.fromJson: fromJson,
      BrickArguments.toJson: toJson,
      BrickArguments.props: QueryConverter.convert(props),
    }).convert();
  }
}
