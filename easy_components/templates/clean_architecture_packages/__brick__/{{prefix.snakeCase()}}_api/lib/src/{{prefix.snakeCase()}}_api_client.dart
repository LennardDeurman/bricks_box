import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part '{{prefix.snakeCase()}}_api_client.g.dart';

@RestApi()
abstract class {{prefix.pascalCase()}}ApiClient {
  factory {{prefix.pascalCase()}}ApiClient(Dio dio) = _CcApiClient;

  /* For example:
  @POST('/example') // @GET('/example')
  Future<ExampleResponseDto> validate(
    @Body() ExampleRequestDto requestObject,
  );
   */

}
