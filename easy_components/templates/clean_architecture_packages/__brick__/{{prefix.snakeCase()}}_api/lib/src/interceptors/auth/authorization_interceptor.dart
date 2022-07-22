import 'dart:io';

import 'package:dio/dio.dart';

import 'access_forbidden_exception.dart';
import 'authorization_manager.dart';
import 'unauthorized_exception.dart';

class AuthorizationInterceptor implements Interceptor {
  final AuthorizationManager _authorizationManager;

  AuthorizationInterceptor(this._authorizationManager);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _authorizationManager.getAccessToken();
    if (accessToken == null) {
      return handler.reject(UnauthorizedException(requestOptions: options));
    }
    final newOptions = options
      ..headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(newOptions);
  }

  @override
  void onResponse(
          Response<dynamic> response, ResponseInterceptorHandler handler) =>
      handler.next(response);

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    final response = error.response;

    final data = response?.data is Map<String, dynamic>
        ? response?.data as Map<String, dynamic>
        : null;
    if ([HttpStatus.unauthorized, 419].contains(response?.statusCode)) {
      handler.reject(UnauthorizedException(
        requestOptions: error.requestOptions,
        data: data,
      ));
    } else if (response?.statusCode == HttpStatus.forbidden) {
      handler.reject(AccessForbiddenException(
        requestOptions: error.requestOptions,
        data: data,
      ));
    } else {
      handler.next(error);
    }
  }
}
