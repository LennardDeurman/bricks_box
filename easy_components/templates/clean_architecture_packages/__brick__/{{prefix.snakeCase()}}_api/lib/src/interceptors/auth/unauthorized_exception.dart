import 'package:dio/dio.dart';

import '../../{{prefix.snakeCase()}}_api_exception.dart';

class UnauthorizedException extends CcApiException {
  UnauthorizedException({
    required RequestOptions requestOptions,
    Map<String, dynamic>? data,
  }) : super(
          requestOptions: requestOptions,
          data: data,
        );

  @override
  String get message => 'User is unauthorized!';
}
