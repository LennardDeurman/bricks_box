import 'package:{{prefix.snakeCase()}}_data/{{prefix.snakeCase()}}_data.dart';
import 'package:get_it/get_it.dart';

class ServiceLocatorDomain {
  static Future<void> init({
    bool isTest = false,
    required String apiBaseUrl,
  }) async {
    // Set up service locator for the data layer
    await ServiceLocatorData.init(
      apiBaseUrl: apiBaseUrl,
    );

    //Add use_cases + services for the domain layer below:
  }
}
