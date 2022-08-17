import 'dart:io';
import 'dart:mirrors';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../model.dart';

void main() async {
  test('Set non-null field to null', () async {
    String? object = '';
    final isSubType = reflect(object).type.isSubtypeOf(reflectType(Null));
    print(isSubType);

  });
}
