import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '{{prefix.snakeCase()}}_api_client.dart';
import '{{prefix.snakeCase()}}_authenticated_api_client.dart';
import 'interceptors/auth/authorization_interceptor.dart';
import 'interceptors/network/network_interceptor.dart';
import 'json_parsing_transformer.dart';

const defaultTimeout = Duration(seconds: 10);

class ServiceLocatorNetworking {
  static void init({
    bool isTest = false,
    required String apiBaseUrl,
  }) {
    final serviceLocator = GetIt.instance;

    serviceLocator.registerLazySingleton(
      () => CcApiClient(
        buildHttpClient(
          serviceLocator: serviceLocator,
          isTest: isTest,
          apiBaseUrl: apiBaseUrl,
        ),
      ),
    );

    serviceLocator.registerLazySingleton(
      () => CcApiAuthenticatedClient(
        buildHttpClient(
          serviceLocator: serviceLocator,
          isAuthenticated: true,
          isTest: isTest,
          apiBaseUrl: apiBaseUrl,
        ),
      ),
    );
  }

  static Dio buildHttpClient({
    required GetIt serviceLocator,
    bool isAuthenticated = false,
    required bool isTest,
    required String apiBaseUrl,
  }) {
    // Set up Dio options
    BaseOptions options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: defaultTimeout.inMilliseconds,
      receiveTimeout: defaultTimeout.inMilliseconds,
      headers: {'Accept': 'application/json'},
    );

    // Set up transformers & interceptors
    final dio = Dio(options)..transformer = JsonParsingTransformer();

    if (isAuthenticated) {
      dio.interceptors.add(AuthorizationInterceptor(serviceLocator.get()));
    }

    if (!isTest && kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: false,
        ),
      );
    }

    // Add network interceptor, except when running tests
    if (!isTest) {
      dio.interceptors.add(NetworkInterceptor());
    }

    // Enables proxy tunneling if "ProxyAddress" is defined
    // e.g. flutter run --dart-define=PROXY='100.100.10.100:8765'
    _enableLogging(dio);

    return dio;
  }

  static void _enableLogging(Dio dio) {
    const proxyAddress = String.fromEnvironment('PROXY', defaultValue: '');

    if (proxyAddress.isNotEmpty) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) => 'PROXY $proxyAddress;';

        // This is a workaround to allow Charles to receive
        // SSL payloads when your app is running on Android.
        client.badCertificateCallback =
            (cert, host, port) => Platform.isAndroid;

        return client;
      };
    }
  }
}
