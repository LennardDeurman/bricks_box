import 'package:recase/recase.dart';

/// Generates test files for the mapper (needs json enabled on the consumed objects)
class DataVerificationGenerator {
  final Map<String, String> _conversions;

  final _TestFileGenerator testFileGenerator = _TestFileGenerator();

  DataVerificationGenerator(this._conversions);
}

class _TestFileGenerator {
  void writeImports(StringBuffer testFileBuffer) {
    testFileBuffer.writeln("import 'dart:convert';");
    testFileBuffer.writeln("import 'package:test/test.dart';");
    testFileBuffer.writeln('');
    testFileBuffer.writeln("import 'seeds.dart';");
    testFileBuffer.writeln('');
  }

  void writeTestBlock({
    required String fromClassName,
    required String toClassName,
    required String variableName,
    required StringBuffer buffer,
  }) {
    buffer.writeln("test('from:$fromClassName to:$toClassName', () {");
    buffer.writeln('expect(jsonEncode($variableName), jsonEncode($variableName.to$toClassName()));');
    buffer.writeln('});');
  }

  String formatGroupBody({
    required String mapperName,
    required List<String> testBodies,
  }) {
    return "group('Conversions for $mapperName', () {\n${testBodies.join('\n\n')}});";
  }

  String formatMethodBody(String body) {
    return "void main() {\n\n$body}}";
  }

  String buildTestContents(List<MapEntry<String, List<String>>> entries) {
    final testFileBuffer = StringBuffer();
    writeImports(testFileBuffer);

    final groupBlocksBuffer = StringBuffer();

    for (final entry in entries) {
      final fromClassName = entry.key.pascalCase;
      final mapperName = '${fromClassName}Mapper';

      final testBodies = <String>[];

      for (var element in entry.value) {
        final variableName = '${element.camelCase}MockObject';

        final buffer = StringBuffer();

        writeTestBlock(
          fromClassName: fromClassName,
          toClassName: element.pascalCase,
          variableName: variableName,
          buffer: buffer,
        );

        testBodies.add(buffer.toString());
      }

      groupBlocksBuffer.write(formatGroupBody(
        mapperName: mapperName,
        testBodies: testBodies,
      ));
      groupBlocksBuffer.writeln('');
      groupBlocksBuffer.writeln('');
    }

    testFileBuffer.write(formatMethodBody(groupBlocksBuffer.toString()));

    return testFileBuffer.toString();
  }
}
