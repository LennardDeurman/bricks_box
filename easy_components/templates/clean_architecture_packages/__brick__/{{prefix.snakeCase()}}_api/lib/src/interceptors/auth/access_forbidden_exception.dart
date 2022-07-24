import 'package:dio/dio.dart';

import '../../{{prefix.snakeCase()}}_api_exception.dart';

class AccessForbiddenException extends {{prefix.snakeCase()}}ApiException {
  AccessForbiddenException({
    required RequestOptions requestOptions,
    Map<String, dynamic>? data,
  }) : super(
          requestOptions: requestOptions,
          data: data,
        );

  @override
  String get message => 'User is not able to access this resource!';
}
