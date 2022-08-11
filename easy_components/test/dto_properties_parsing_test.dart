import 'package:test/test.dart';
import 'package:input_parser/input_parser.dart';

void main() {
  test('Test dto properties parsing', () {
    final pair = 'String:accountId/https://tareas.nl/account_id';

    final separatorIndex = pair.indexOf(':');

    final type = pair.substring(0, separatorIndex);

    final isOptional = type.endsWith('?');
    final right = pair.substring(separatorIndex + 1, pair.length);

    final defaultValueStartIndex = right.indexOf('=');
    final hasDefault = defaultValueStartIndex > -1;
    final keyStartIndex = right.indexOf('/') + 1;

    final key = right.substring(
        keyStartIndex, hasDefault ? defaultValueStartIndex : right.length);
    final name = right.substring(0, keyStartIndex - 1);
    final defaultValue = hasDefault
        ? right.substring(defaultValueStartIndex + 1, right.length)
        : null;

    final prop = DtoProperty(
      isOptional: isOptional,
      type: type,
      defaultValue: defaultValue,
      name: name,
      key: key,
    );

    expect(prop.key, 'https://tareas.nl/account_id');
  });
}
