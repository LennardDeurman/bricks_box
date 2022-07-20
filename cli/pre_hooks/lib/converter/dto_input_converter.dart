import 'converter.dart';
import 'package:input_parser/input_parser.dart';

class DtoInputConverter extends Converter {
  DtoInputConverter(Map<String, dynamic> original) : super(original);

  @override
  Map<String, dynamic> convert() {
    String? classFields;
    String? equatableProps;
    String? constructor;
    if (original.containsKey('props')) {
      final props = original['props'];
      if (props is String) {
        final parsedResult = DtoPropertiesParser(props).parse();
        classFields = parsedResult?.classFields;
        equatableProps = parsedResult?.propsBody;
        constructor = parsedResult?.constructorBody;
      }
    }

    final toJson = original['to_json'] ?? true;
    final fromJson = original['from_json'] ?? true;

    String jsonConstructor = '';
    if (!fromJson) {
      jsonConstructor = 'createFactory:false';
    } else if (!toJson) {
      jsonConstructor = 'toJson:false';
    }

    // Read/Write vars
    return {
      ...original,
      'equatable_props': equatableProps,
      'constructor': constructor,
      'class_props': classFields,
      'json_constructor': jsonConstructor,
    };
  }
}
