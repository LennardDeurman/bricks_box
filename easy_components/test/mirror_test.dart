import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';
import 'package:recase/recase.dart';
import 'package:test/test.dart';

import 'test.models.dart';

void main() {
  test('Test with output', () {
    final map = <String, String>{};

    map['MirrorTestEntity:MirrorTest'] = _mk(MirrorTestEntity, MirrorTest);

    File('output.json').writeAsString(jsonEncode(map));
  });
}

String _mk(Type from, Type to) {
  final inputClassParameters = _getConstructorParameters(from);
  final outputClassParameters = _getConstructorParameters(to);

  final fieldAssignations = <String>[];

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
        output =
            '$name.map((item) => item.to${childType.toString().pascalCase}()).toList()';
      } else {
        output = '$name.to${mirror.type.reflectedType.toString().pascalCase}()';
      }
    }

    final input = '$name: $output';
    fieldAssignations.add(input);
  }

  return '${fieldAssignations.join(',\n')},';
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

  final constructor = constructors
      .firstWhere((element) => element is MethodMirror) as MethodMirror;
  return constructor.parameters;
}
