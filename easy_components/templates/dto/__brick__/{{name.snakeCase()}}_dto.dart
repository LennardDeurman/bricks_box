import 'package:equatable/equatable.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

{{{imports}}}

part '{{name.snakeCase()}}_dto.g.dart';

@JsonSerializable({{json_constructor}})
@CopyWith()
class {{name.pascalCase()}}Dto extends Equatable {
  {{{class_props}}}

  const {{name.pascalCase()}}Dto({{constructor}});

  @override
  List<Object?> get props => [{{equatable_props}}];

  {{#from_json}}factory {{name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) => _${{name.pascalCase()}}DtoFromJson(json);{{/from_json}}

  {{#to_json}}Map<String, dynamic> toJson() => _${{name.pascalCase()}}DtoToJson(this);{{/to_json}}

}

