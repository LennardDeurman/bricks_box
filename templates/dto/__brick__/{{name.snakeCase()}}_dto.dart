import 'package:equatable/equatable.dart';

part '{{name.snakeCase()}}.g.dart';

@JsonSerializable({{json_constructor}})
@CopyWith(generateCopyWithNull:true)
class {{name.pascalCase()}}Dto extends Equatable {
  {{class_props}}

  const {{name.pascalCase()}}Dto({{constructor}});

  @override
  List<Object?> get props => [{{equatable_props}}];

  {{#from_json}}factory {{name.pascalCase()}}Dto.fromJson(Map<String, dynamic> json) => _${{name.pascalCase()}}DtoFromJson(json);{{/from_json}}

  {{#to_json}}Map<String, dynamic> toJson() => _${{name.pascalCase()}}ToJson(this);{{/to_json}}

}

