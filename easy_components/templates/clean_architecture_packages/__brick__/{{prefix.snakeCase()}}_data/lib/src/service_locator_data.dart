import 'package:{{prefix.snakeCase()}}_api/{{prefix.snakeCase()}}_api.dart';
import 'package:{{prefix.snakeCase()}}_domain/{{prefix.snakeCase()}}_domain.dart';
import 'package:{{prefix.snakeCase()}}_storage/{{prefix.snakeCase()}}_storage.dart';
import 'package:get_it/get_it.dart';


class ServiceLocatorData {
  static Future<void> init({
    bool isTest = false,
    required String apiBaseUrl,
  }) async {
    final serviceLocator = GetIt.instance;

    ServiceLocatorNetworking.init(
      isTest: isTest,
      apiBaseUrl: apiBaseUrl,
    );

    await ServiceLocatorStorage.init(isTest: isTest);
  }
}
