import 'package:mason/mason.dart';
import 'package:common/common.dart';

void run(HookContext context) {
  String? classFields = null;
  String? equatableProps = null;
  String? constructor = null;
  if (context.vars.containsKey('props')) {
    final props = context.vars['props'];
    if (props is String) {
      final parsedResult = ModelPropertiesParser(props).parse();
      classFields = parsedResult?.classFields;
      equatableProps = parsedResult?.propsBody;
      constructor = parsedResult?.constructorBody;
    }
  }

  // Read/Write vars
  context.vars = {
    ...context.vars,
    'equatable_props': equatableProps,
    'constructor': constructor,
    'class_props': classFields,
  };
}
