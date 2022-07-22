import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class JsonParsingTransformer extends DefaultTransformer {
  JsonParsingTransformer() : super(jsonDecodeCallback: _parseJson);
}

dynamic _parseAndDecode(String response) => jsonDecode(response);
Future<dynamic> _parseJson(String text) => compute(_parseAndDecode, text);
