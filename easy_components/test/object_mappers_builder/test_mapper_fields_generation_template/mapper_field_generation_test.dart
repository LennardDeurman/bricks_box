import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';
import 'package:recase/recase.dart';
import 'package:test/test.dart';

import 'dependencies/test.models.dart';

/// This is a basic test for the template in mason which cannot be tested itself
/// Make sure it conforms with the template in templates/mapper_generator/mapper_generator.dart

void main() {
  test('Test the creation of the json output file', () async {
    final classes = [
      MirrorTestEntity,
      MirrorTestChildEntity,
    ];

    final items = classes.map((className) async {
      final contents = await readContents(reflectType(className));
      return MapEntry(className.toString(), contents);
    }).toList();

    final classEntries = await Future.wait(items);
    final classContents = Map.fromEntries(classEntries);

    final map = <String, dynamic>{};

    map['MirrorTestEntity:MirrorTest'] =
        _mk(MirrorTestEntity, MirrorTest, classContents);
    map['MirrorTestChildEntity:MirrorTestChild'] =
        _mk(MirrorTestChildEntity, MirrorTestChild, classContents);

    await File('output.json').writeAsString(jsonEncode(map));

    expect(await File('output.json').exists(), true);
  });
}

Future<String?> readContents(TypeMirror mirror) async {
  final sourceUri = mirror.location?.sourceUri;
  if (sourceUri != null) {
    final file = File.fromUri(sourceUri);
    return file.readAsString();
  }
  return null;
}

Map<String, dynamic> _mk(
    Type from, Type to, Map<String, String?> classContents) {
  final fromTypeMirror = reflectClass(from);

  final inputClassParameters = _getConstructorParameters(fromTypeMirror);
  final outputClassParameters = _getConstructorParameters(reflectClass(to));

  final fieldAssignations = <String>[];
  final List<String> unknownTypes = [];

  final classContent = classContents.containsKey(from.toString())
      ? classContents[from.toString()]
      : null;

  for (ParameterMirror mirror in outputClassParameters) {
    final name = MirrorSystem.getName(mirror.simpleName);
    final elements = inputClassParameters
        .where((element) => element.simpleName == mirror.simpleName);

    var output = 'null';

    bool isOptional = false;

    if (classContent != null) {
      final regEx = '(?<=final\\s).*(?=\\s$name;)';
      final match = RegExp(regEx).firstMatch(classContent);
      final typeAsString = match?.group(0);
      isOptional = typeAsString?.contains('?') == true;
    }

    if (elements.isNotEmpty) {
      final inputMirror = elements.first;
      if (inputMirror.type == mirror.type) {
        output = name;
      } else if (inputMirror.type.isSubtypeOf(reflectType(List))) {
        final childType = mirror.type.typeArguments.first.reflectedType;
        final typeName = childType.toString().pascalCase;
        if (isOptional) {
          output = '$name?.map((item) => item.to$typeName()).toList()';
        } else {
          output = '$name.map((item) => item.to$typeName()).toList()';
        }

        unknownTypes.add(inputMirror.type.typeArguments.first.reflectedType
            .toString()
            .pascalCase);
      } else {
        final typeName = mirror.type.reflectedType.toString().pascalCase;

        if (isOptional) {
          output = '$name?.to$typeName()';
        } else {
          output = '$name.to$typeName()';
        }

        unknownTypes.add(inputMirror.type.reflectedType.toString().pascalCase);
      }
    }

    final input = '$name: $output';
    fieldAssignations.add(input);
  }

  return {
    'output': '${fieldAssignations.join(',\n')},',
    'unknown_types': unknownTypes.map((e) => e.snakeCase).toList(),
  };
}

List<ParameterMirror> _getConstructorParameters(ClassMirror info) {
  final declarations = info.declarations;

  List<DeclarationMirror> constructors = List.from(
    declarations.values.where(
      (declare) {
        return declare is MethodMirror && declare.isConstructor;
      },
    ),
  );

  final constructor = constructors
      .firstWhere((element) => element is MethodMirror) as MethodMirror;
  return constructor.parameters;
}
