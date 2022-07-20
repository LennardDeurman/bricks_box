part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Cubit extends Cubit<{{name.pascalCase()}}State> {

  {{name.pascalCase()}}Cubit() : super({{name.pascalCase()}}State.initial()) {
    Future.delayed(Duration.zero, _init);
  }

  Future<void> _init() async {

  }


}