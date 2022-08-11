{{#use_equatable}}import 'package:equatable/equatable.dart';{{/use_equatable}}{{#use_copy_with}}
import 'package:copy_with_extension/copy_with_extension.dart';

part '{{name.snakeCase()}}.g.dart';

@CopyWith({{#generate_copy_with_null}}generateCopyWithNull:true{{/generate_copy_with_null}}){{/use_copy_with}}
class {{name.pascalCase()}} {{#use_equatable}}extends Equatable{{/use_equatable}} {
  {{{class_props}}}

  const {{name.pascalCase()}}({{constructor}});

  {{#use_equatable}}@override
  List<Object?> get props => [{{equatable_props}}];{{/use_equatable}}

}

