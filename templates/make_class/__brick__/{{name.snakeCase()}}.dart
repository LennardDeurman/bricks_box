{{#use_equatable}}import 'package:equatable/equatable.dart';{{/use_equatable}}{{#use_copy_with}}

part '{{name.snakeCase()}}.g.dart';

@CopyWith(){{/use_copy_with}}
class {{name.pascalCase()}} {{#use_equatable}}extends Equatable{{/use_equatable}} {
  {{class_props}}
  const {{name.pascalCase()}}({{constructor}});

  {{#use_equatable}}@override
  List<Object?> get props => [{{equatable_props}}];{{/use_equatable}}

}

