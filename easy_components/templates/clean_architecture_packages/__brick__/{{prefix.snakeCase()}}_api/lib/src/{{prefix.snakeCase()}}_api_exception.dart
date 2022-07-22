import 'package:dio/dio.dart';

class {{prefix.pascalCase()}}ApiException extends DioError {
  final Map<String, dynamic>? data;

  {{prefix.pascalCase()}}ApiException({
    required RequestOptions requestOptions,
    this.data,
    Response? response,
    error,
  }) : super(requestOptions: requestOptions, response: response, error: error);

  @override
  String toString() {
    return response?.data['message'] ?? '';
  }
}
