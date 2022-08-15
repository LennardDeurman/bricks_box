import '';
import 'parsed_field.dart';

class YamlParser {
  static ParsedField parse(String name, String value) {
    return ParsedField(
      name: name,
      className: determineClassName(value),
      isOptional: value.contains('?'),
      defaultValue: determineDefault(value),
      key: determineKey(value),
    );
  }

  static String determineClassName(String value) {
    String className;
    if (value.contains('=')) {
      className = value.substring(0, value.indexOf('='));
    } else if (value.contains('/')) {
      className = value.substring(0, value.indexOf('/'));
    } else {
      className = value;
    }
    return className;
  }

  static String? determineKey(String value) {
    if (value.contains('/')) {
      return value.substring(value.indexOf('/') + 1, value.length);
    }

    return null;
  }

  static String? determineDefault(String value) {
    if (value.contains('=')) {
      final keySeparator = value.indexOf('/');

      return value.substring(value.indexOf('=') + 1,
          keySeparator > -1 ? keySeparator : value.length);
    }

    return null;
  }
}
