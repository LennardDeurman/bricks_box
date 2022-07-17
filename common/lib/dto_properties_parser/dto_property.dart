import 'package:common/model_properties_parser/model_property.dart';

class DtoProperty extends ModelProperty {
  final String key;

  const DtoProperty({
    required bool isOptional,
    required String name,
    required String type,
    required this.key,
    String? defaultValue,
  }) : super(
          isOptional: isOptional,
          name: name,
          type: type,
          defaultValue: defaultValue,
        );
}
