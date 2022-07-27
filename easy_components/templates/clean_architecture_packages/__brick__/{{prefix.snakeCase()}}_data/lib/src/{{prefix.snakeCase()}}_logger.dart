import 'package:logger/logger.dart';

class {{prefix.pascalCase()}}Logger {
  late final Logger _logger;

{{prefix.pascalCase()}}Logger._internal() {
    _logger = Logger();
  }

  static final {{prefix.pascalCase()}}Logger _instance = {{prefix.pascalCase()}}Logger._internal();

  factory {{prefix.pascalCase()}}Logger() => _instance;

  static Logger get instance => _instance._logger;
}
