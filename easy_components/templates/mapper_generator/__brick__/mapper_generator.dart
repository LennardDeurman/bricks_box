import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';
import 'package:recase/recase.dart';
import 'package:test/test.dart';

{{{imports}}}

void main() {
  final map = <String, String>{};

  {{{code_lines}}}

  File('output.json').writeAsString(jsonEncode(map));
}

Map<String, dynamic> _mk(Type from, Type to) {
  final inputClassParameters = _getConstructorParameters(from);
  final outputClassParameters = _getConstructorParameters(to);

  final fieldAssignations = <String>[];
  final List<String> unknownTypes = [];

  for (ParameterMirror mirror in outputClassParameters) {
    final name = MirrorSystem.getName(mirror.simpleName);
    final elements = inputClassParameters
        .where((element) => element.simpleName == mirror.simpleName);

    var output = 'null';

    if (elements.isNotEmpty) {
      final inputMirror = elements.first;
      if (inputMirror.type == mirror.type) {
        output = name;
      } else if (inputMirror.type.isSubtypeOf(reflectType(List))) {
        final childType = mirror.type.typeArguments.first.reflectedType;
        final typeName = childType.toString().pascalCase;
        if (inputMirror.isOptional) {
          output = '$name?.map((item) => item.to$typeName()).toList()';
        } else {
          output = '$name.map((item) => item.to$typeName()).toList()';
        }

        unknownTypes.add(typeName);
      } else {
        final typeName = mirror.type.reflectedType.toString().pascalCase;
        if (inputMirror.isOptional) {
          output = '$name?.to$typeName()';
        } else {
          output = '$name.to$typeName()';
        }

        unknownTypes.add(typeName);
      }
    }


    final input = '$name: $output';
    fieldAssignations.add(input);
  }

  return {
    'output': '${fieldAssignations.join(',\n')},',
    'unknown_types': unknownTypes.map((e) => e.snakeCase),
  };
}

List<ParameterMirror> _getConstructorParameters(Type type) {
  final info = reflectClass(type);
  List<DeclarationMirror> constructors = List.from(
    info.declarations.values.where(
          (declare) {
        return declare is MethodMirror && declare.isConstructor;
      },
    ),
  );

  final constructor = constructors.firstWhere((element) => element is MethodMirror) as MethodMirror;
  return constructor.parameters;
}

