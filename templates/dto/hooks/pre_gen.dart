import 'dart:convert';

import 'package:mason/mason.dart';
import 'package:common/common.dart';

void run(HookContext context) {
  String? classFields = null;
  String? equatableProps = null;
  String? constructor = null;
  if (context.vars.containsKey('props')) {
    final props = context.vars['props'];
    if (props is String) {
      final parsedResult = DtoPropertiesParser(props).parse();
      classFields = parsedResult?.classFields;
      equatableProps = parsedResult?.propsBody;
      constructor = parsedResult?.constructorBody;
    }
  }

  final toJson = context.vars['to_json'] ?? true;
  final fromJson = context.vars['from_json'] ?? true;

  String jsonConstructor = '';
  if (!fromJson) {
    jsonConstructor = 'createFactory:false';
  } else if (!toJson) {
    jsonConstructor = 'toJson:false';
  }

  // Read/Write vars
  context.vars = {
    ...context.vars,
    'equatable_props': equatableProps,
    'constructor': constructor,
    'class_props': classFields,
    'json_constructor': jsonConstructor,
  };
}
