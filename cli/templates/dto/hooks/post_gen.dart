import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  await Process.run(
    'dart',
    ['format', '.'],
    runInShell: true,
  );
}
