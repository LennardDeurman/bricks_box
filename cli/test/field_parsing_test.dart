import 'package:test/test.dart';

void main() {
  String _determineClassName(String value) {
    String className;
    if (value.contains('/')) {
      className = value.substring(0, value.indexOf('/'));
    } else if (value.contains('=')) {
      className = value.substring(0, value.indexOf('='));
    } else {
      className = value;
    }
    return className;
  }

  String? _determineKey(String value) {
    if (value.contains('/')) {
      final defaultSignIndex = value.indexOf('=');
      return value.substring(value.indexOf('/') + 1, defaultSignIndex > -1 ? defaultSignIndex : value.length);
    }

    return null;
  }

  String? _determineDefault(String value) {
    if (value.contains('=')) {
      return value.substring(value.indexOf('=') + 1, value.length);
    }

    return null;
  }

  test('determine className', () {
    expect(_determineClassName('String?'), 'String?');
    expect(_determineClassName('String?/user_id'), 'String?');
    expect(_determineClassName('String?/user_id=0'), 'String?');
    expect(_determineClassName('String?=0'), 'String?');
  });

  test('determine key', () {
    expect(_determineKey('String?/user_id'), 'user_id');
    expect(_determineKey('String?/user_id=0'), 'user_id');
  });

  test('determine defaults', () {
    expect(_determineDefault('String?=0'), '0');
    expect(_determineDefault('String?/user_id=0'), '0');
  });
}
