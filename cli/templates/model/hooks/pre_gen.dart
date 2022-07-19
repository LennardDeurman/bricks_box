import 'package:mason/mason.dart';
import 'package:pre_hooks/converter/model_input_converter.dart';

void run(HookContext context) => context.vars = ModelInputConverter(context.vars).convert();
