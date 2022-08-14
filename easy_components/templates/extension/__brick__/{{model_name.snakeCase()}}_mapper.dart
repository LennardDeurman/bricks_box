import 'package:{{{prefix}}}_api/{{{prefix}}}_api.dart';
import 'package:{{{prefix}}}_storage/{{{prefix}}}_storage.dart';
import 'package:{{{prefix}}}_domain/{{{prefix}}}_domain.dart';

{{{imports}}}

extension {{{model_name.pascalCase()}}}Mapper on {{{model_name.pascalCase()}}} {
  {{{body}}}
}