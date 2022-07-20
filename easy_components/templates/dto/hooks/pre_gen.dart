import 'package:pre_hooks/converter/dto_input_converter.dart';
import 'package:mason/mason.dart';

void run(HookContext context) =>
    context.vars = DtoInputConverter(context.vars).convert();
