import '../constants/brick_arguments.dart';
import '../constants/global.dart';
import '../map_extension.dart';
import '../query_converter.dart';
import 'builder.dart';

class DtoBuilder extends Builder {

  DtoBuilder (Map<String, dynamic> config) : super(config: config, brickPath: Constants.brickDtoLocation);

  @override
  Map<String, dynamic> toInputMap(String modelName, Map<String, dynamic> yamlMap) {
    final fromJson = yamlMap.get<bool>(BrickArguments.fromJson, true);
    final toJson = yamlMap.get<bool>(BrickArguments.toJson, true);

    final props = yamlMap[BrickArguments.props] as Map<String, String>;

    return {
      BrickArguments.name: modelName,
      BrickArguments.fromJson: fromJson,
      BrickArguments.toJson: toJson,
      BrickArguments.props: QueryConverter.convert(props.entries.toList()),
    };
  }

}