import 'package:common/model_properties_parser/model_properties_result.dart';

import 'model_property.dart';

class ModelPropertiesParser {
  final String _input;

  ModelPropertiesParser(this._input);

  String _buildClassFields(List<ModelProperty> props) {
    return props.map((prop) => 'final ${prop.type} ${prop.name};').join('\n');
  }

  String _buildProps(List<ModelProperty> props) {
    return props.map((prop) => prop.name).join(',\n');
  }

  String _buildConstructorBody(List<ModelProperty> props) {
    return props.map((prop) => 'this.${prop.name}').join(', ');
  }

  ModelPropertiesResult? parse() {
    if (_input.isEmpty) return null;
    final items = _input.split(',');
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
    return ModelPropertiesResult(
      classFields: _buildClassFields(props),
      constructorBody: _buildConstructorBody(props),
      propsBody: _buildProps(props),
    );
  }
}
