import 'package:dio/dio.dart';

class NoNetworkException extends DioError {
  NoNetworkException(RequestOptions requestOptions)
      : super(requestOptions: requestOptions);

  @override
  String get message => 'No network connection!';
}
