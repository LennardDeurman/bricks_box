part of '{{name.snakeCase()}}_cubit.dart';

class {{name.pascalCase()}}State {
  final {{name.pascalCase()}}Data data;

  const {{name.pascalCase()}}State({ required this.data });


  factory {{name.pascalCase()}}State.initial() {
    return {{name.pascalCase()}}State(data: {{name.pascalCase()}}Data());
  }

  {{name.pascalCase()}}State copyWith({ {{name}}? data }) {
    return {{name.pascalCase()}}State(data: this.data ?? data);
  }
}