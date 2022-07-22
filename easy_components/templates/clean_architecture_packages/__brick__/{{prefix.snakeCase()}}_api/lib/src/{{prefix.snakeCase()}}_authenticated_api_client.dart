import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part '{{prefix.snakeCase()}}_authenticated_api_client.g.dart';

@RestApi()
abstract class {{prefix.pascalCase()}}ApiAuthenticatedClient {
  factory {{prefix.pascalCase()}}ApiAuthenticatedClient(Dio dio) = _{{prefix.pascalCase()}}ApiAuthenticatedClient;

  /* For example:
  @POST('/example') // @GET('/example')
  Future<ExampleResponseDto> validate(
    @Body() ExampleRequestDto requestObject,
  );
   */
}
