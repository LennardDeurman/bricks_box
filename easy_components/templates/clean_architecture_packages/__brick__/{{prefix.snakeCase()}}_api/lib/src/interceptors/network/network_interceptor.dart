import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../../{{prefix.snakeCase()}}_api_exception.dart';
import 'no_network_exception.dart';

class NetworkInterceptor implements Interceptor {
  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    final data = error.response?.data is Map<String, dynamic>
        ? error.response?.data as Map<String, dynamic>
        : null;
    handler.next(
      {{prefix.snakeCase()}}ApiException(
        requestOptions: error.requestOptions,
        data: data,
        response: error.response,
      ),
    );
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none)
      return handler.reject(NoNetworkException(options));
    return handler.next(options);
  }

  @override
  void onResponse(
          Response<dynamic> response, ResponseInterceptorHandler handler) =>
      handler.next(response);
}
