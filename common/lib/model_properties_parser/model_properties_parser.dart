import 'package:common/class_structure_result.dart';

import 'model_property.dart';

class ModelPropertiesParser {
  final String input;

  ModelPropertiesParser(this.input);

  String buildClassFields(List<ModelProperty> props) {
    return props.map((prop) => 'final ${prop.type} ${prop.name};').join('\n');
  }

  String buildProps(List<ModelProperty> props) {
    final propsStr = props.map((prop) => prop.name).join(',\n');
    if (propsStr.isNotEmpty) return '$propsStr,';
    return '';
  }

  String buildConstructorBody(List<ModelProperty> props) {
    final constructorBody = props.map((prop) {
      final propStr = 'this.${prop.name}';
      String result;
      if (prop.isOptional) {
        result = propStr;
      } else {
        result = 'required $propStr';
      }

      if (prop.defaultValue != null) {
        return '$result=${prop.defaultValue}';
      }
      return result;
    }).join(', ');
    return '{$constructorBody}';
  }

  ClassStructureResult? parse() {
    if (input.isEmpty) return null;
    final items = input.split(',');
    List<ModelProperty> props = [];
    for (var pair in items) {
      final parts = pair.split(':');
      final type = parts[0];
      final isOptional = type.endsWith('?');
      final right = parts[1];
      final rightParts = right.split('=');
      String? defaultValue;
      String name;
      if (rightParts.length > 1) {
        defaultValue = rightParts[1];
        name = rightParts[0];
      } else {
        name = right;
      }
      final prop = ModelProperty(
        isOptional: isOptional,
        type: type,
        defaultValue: defaultValue,
        name: name,
      );
      props.add(prop);
    }
    return ClassStructureResult(
      classFields: buildClassFields(props),
      constructorBody: buildConstructorBody(props),
      propsBody: buildProps(props),
    );
  }
}
