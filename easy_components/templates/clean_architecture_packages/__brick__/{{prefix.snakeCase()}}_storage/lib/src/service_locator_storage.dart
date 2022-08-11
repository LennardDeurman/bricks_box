import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocatorStorage {
  static Future<void> init({bool isTest = false}) async {
    if (isTest) {
      // ignore: invalid_use_of_visible_for_testing_member
      SharedPreferences.setMockInitialValues({});
    }

    final serviceLocator = GetIt.instance;
    final sharedPrefs = await SharedPreferences.getInstance();

    serviceLocator.registerSingleton(sharedPrefs);
    serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());
    serviceLocator
        .registerLazySingleton(() => SessionStore(serviceLocator.get()));
  }
}
