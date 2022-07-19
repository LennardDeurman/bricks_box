import '../constants/brick_arguments.dart';
import '../constants/global.dart';
import '../map_extension.dart';
import '../query_converter.dart';
import 'builder.dart';

class ModelBuilder extends Builder {

  ModelBuilder (Map<String, dynamic> config) : super(config: config, brickPath: Constants.brickModelLocation);

  @override
  Map<String, dynamic> toInputMap(String modelName, Map<String, dynamic> yamlMap) {
    final useEquatable = yamlMap.get<bool>(BrickArguments.useEquatable, true);
    final generateCopyWithNull = yamlMap.get<bool>(BrickArguments.generateCopyWithNull, true);
    final useCopyWith = yamlMap.get<bool>(BrickArguments.useCopyWith, true);

    final props = yamlMap[BrickArguments.props] as Map<String, String>;


    return {
      BrickArguments.name: modelName,
      BrickArguments.generateCopyWithNull: generateCopyWithNull,
      BrickArguments.useCopyWith: useCopyWith,
      BrickArguments.useEquatable: useEquatable,
      BrickArguments.props: QueryConverter.convert(props.entries.toList()),
    };
  }

}