import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part '{{name.snakeCase()}}_data.g.dart';

@CopyWith()
class {{name.pascalCase()}}Data extends Equatable {
  const {{name.pascalCase()}}Data();

  @override
  List<Object?> get props => [];
}