import 'converter.dart';
import 'package:input_parser/input_parser.dart';

class ModelInputConverter extends Converter {
  ModelInputConverter(Map<String, dynamic> original) : super(original);

  @override
  Map<String, dynamic> convert() {
    String? classFields;
    String? equatableProps;
    String? constructor;
    if (original.containsKey('props')) {
      final props = original['props'];
      if (props is String) {
        final parsedResult = ModelPropertiesParser(props).parse();
        classFields = parsedResult?.classFields;
        equatableProps = parsedResult?.propsBody;
        constructor = parsedResult?.constructorBody;
      }
    }

    // Read/Write vars
    return {
      ...original,
      'equatable_props': equatableProps,
      'constructor': constructor,
      'class_props': classFields,
    };
  }
}
