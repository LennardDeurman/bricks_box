import 'package:copy_with_extension/copy_with_extension.dart';

part '{{name.snakeCase()}}_data.g.dart';

@CopyWith(generateCopyWithNull: true)
class {{name.pascalCase()}}Data {
  const {{name.pascalCase()}}Data();
}