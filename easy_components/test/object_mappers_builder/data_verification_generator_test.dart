import 'package:test/test.dart';

import '../../bin/objects_mapper/data_verification_generator.dart';
import 'mocks.dart';

void main() {
  group('Test automatic generated tests generation for the mapper classes', () {
    test('Test write imports', () {
      final buffer = StringBuffer();
      final generator = DataVerificationGenerator(Map.fromEntries(mockSingleEntries));
      generator.testFileGenerator.writeImports(buffer);
      expect(
        buffer.toString(),
        "import 'dart:convert';\n"
            "import 'package:test/test.dart';\n\n"
            "import 'seeds.dart';\n\n",
      );
    });

    test('Write test block', () {
      final buffer = StringBuffer();
      final generator = DataVerificationGenerator(Map.fromEntries(mockSingleEntries));
      generator.testFileGenerator.writeTestBlock(
        fromClassName: 'Mirror',
        toClassName: 'MirrorEntity',
        variableName: 'mockMirror',
        buffer: buffer,
      );
      expect(
          buffer.toString(),
          'test(\'from:Mirror to:MirrorEntity\', () {\n'
              'expect(jsonEncode(mockMirror), jsonEncode(mockMirror.toMirrorEntity()));\n'
              '});\n'
              '');
    });

    test('Format group body', () {
      final testBodies = [
        'test(\'from:Mirror to:MirrorEntity\', () {\n'
            'expect(jsonEncode(mockMirror), jsonEncode(mockMirror.toMirrorEntity()));\n'
            '});\n'
      ];

      final generator = DataVerificationGenerator(Map.fromEntries(mockSingleEntries));
      final output = generator.testFileGenerator.formatGroupBody(
        mapperName: 'MirrorMapper',
        testBodies: testBodies,
      );

      final expectedOutput = 'group(\'Conversions for MirrorMapper\', () {\n'
          'test(\'from:Mirror to:MirrorEntity\', () {\n'
          'expect(jsonEncode(mockMirror), jsonEncode(mockMirror.toMirrorEntity()));\n'
          '});\n'
          '});';

      expect(output, expectedOutput);
    });

    test('Format method body', () {
      final generator = DataVerificationGenerator(Map.fromEntries(mockSingleEntries));
      final groupBody = 'group(\'Conversions for MirrorMapper\', () {\n'
          'test(\'from:Mirror to:MirrorEntity\', () {\n'
          'expect(jsonEncode(mockMirror), jsonEncode(mockMirror.toMirrorEntity()));\n'
          '});\n'
          '});';
      final output = generator.testFileGenerator.formatMethodBody(groupBody);
      expect(
        output,
        'void main() {\n'
            '\n'
            'group(\'Conversions for MirrorMapper\', () {\n'
            'test(\'from:Mirror to:MirrorEntity\', () {\n'
            'expect(jsonEncode(mockMirror), jsonEncode(mockMirror.toMirrorEntity()));\n'
            '});\n'
            '});}}',
      );
    });

    test('Total file contents', () {
      final generator = DataVerificationGenerator(Map.fromEntries(mockSingleEntries));
      final contents = generator.testFileGenerator.buildTestContents(mockEntries);
      final expected = 'import \'dart:convert\';\n'
          'import \'package:test/test.dart\';\n'
          '\n'
          'import \'seeds.dart\';\n'
          '\n'
          'void main() {\n'
          '\n'
          'group(\'Conversions for MirrorTestMapper\', () {\n'
          'test(\'from:MirrorTest to:MirrorTestEntity\', () {\n'
          'expect(jsonEncode(mirrorTestEntityMockObject), jsonEncode(mirrorTestEntityMockObject.toMirrorTestEntity()));\n'
          '});\n'
          '});\n'
          '\n'
          'group(\'Conversions for MirrorTestChildMapper\', () {\n'
          'test(\'from:MirrorTestChild to:MirrorTestChildEntity\', () {\n'
          'expect(jsonEncode(mirrorTestChildEntityMockObject), jsonEncode(mirrorTestChildEntityMockObject.toMirrorTestChildEntity()));\n'
          '});\n'
          '});\n'
          '\n'
          'group(\'Conversions for MirrorTestEntityMapper\', () {\n'
          'test(\'from:MirrorTestEntity to:MirrorTest\', () {\n'
          'expect(jsonEncode(mirrorTestMockObject), jsonEncode(mirrorTestMockObject.toMirrorTest()));\n'
          '});\n'
          '});\n'
          '\n'
          'group(\'Conversions for MirrorTestChildEntityMapper\', () {\n'
          'test(\'from:MirrorTestChildEntity to:MirrorTestChild\', () {\n'
          'expect(jsonEncode(mirrorTestChildMockObject), jsonEncode(mirrorTestChildMockObject.toMirrorTestChild()));\n'
          '});\n'
          '});\n'
          '\n'
          '}}';
      expect(contents, expected);
    });
  });
}