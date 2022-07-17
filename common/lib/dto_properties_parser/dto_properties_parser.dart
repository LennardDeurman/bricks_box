import 'package:common/class_structure_result.dart';
import 'package:common/common.dart';
import 'package:common/dto_properties_parser/dto_property.dart';
import 'package:common/model_properties_parser/model_property.dart';

class DtoPropertiesParser extends ModelPropertiesParser {

  DtoPropertiesParser(String input) : super(input);

  String _buildClassFields(List<DtoProperty> props) {
    return props.map((prop) {
      String keyDefinition;
      if (prop.defaultValue != null) {
        keyDefinition = '@JsonKey(name: ${prop.key}, defaultValue: ${prop.defaultValue});';
      } else {
        keyDefinition = '@JsonKey(name: ${prop.key});';
      }
      final fieldDefinition = 'final ${prop.type} ${prop.name};';
      return '$keyDefinition\n$fieldDefinition';
    }).join('\n');
  }


  String _buildConstructorBody(List<ModelProperty> props) {
    final constructorBody = props.map((prop) {
      final propStr = 'this.${prop.name}';
      return 'required $propStr';
    }).join(', ');
    return '{$constructorBody}';
  }

  @override
  ClassStructureResult? parse() {
    if (input.isEmpty) return null;
    final items = input.split(',');
    List<DtoProperty> props = [];
    for (var pair in items) {
      final parts = pair.split(':');
      final type = parts[0];
      final isOptional = type.endsWith('?');
      final right = parts[1];

      final defaultValueStartIndex = right.indexOf('=');
      final hasDefault = defaultValueStartIndex > -1;
      final keyStartIndex = right.indexOf('/');

      final key = right.substring(keyStartIndex, hasDefault ? defaultValueStartIndex : right.length);
      final name = right.substring(0, keyStartIndex);
      final defaultValue = hasDefault ? right.substring(defaultValueStartIndex, right.length) : null;

      final prop = DtoProperty(
        isOptional: isOptional,
        type: type,
        defaultValue: defaultValue,
        name: name,
        key: key,
      );
      props.add(prop);
    }
    return ClassStructureResult(
      classFields: _buildClassFields(props),
      constructorBody: _buildConstructorBody(props),
      propsBody: buildProps(props),
    );
  }
}
