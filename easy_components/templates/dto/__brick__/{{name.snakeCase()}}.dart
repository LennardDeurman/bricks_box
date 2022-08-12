import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

{{{imports}}}

part '{{name.snakeCase()}}.g.dart';

@JsonSerializable({{json_constructor}})
@CopyWith()
class {{name.pascalCase()}} extends Equatable {
  {{{class_props}}}

  const {{name.pascalCase()}}({{constructor}});

  @override
  List<Object?> get props => [{{equatable_props}}];

  {{#from_json}}factory {{name.pascalCase()}}.fromJson(Map<String, dynamic> json) => _${{name.pascalCase()}}FromJson(json);{{/from_json}}

  {{#to_json}}Map<String, dynamic> toJson() => _${{name.pascalCase()}}ToJson(this);{{/to_json}}

}

