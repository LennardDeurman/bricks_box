import 'package:test/test.dart';
import 'package:input_parser/model_properties_parser/model_properties_parser.dart';

void main() {
  test('Test output', () {
    const test =
        'String?:name=Lennard,int?:id=0,bool:isAllowed,String?:firstName';
    final props = ModelPropertiesParser(test).parse();
    expect(props, isNotNull);
    expect(props!.constructorBody,
        '{required this.isAllowed,this.firstName,this.name=Lennard,this.id=0,}');
    expect(
      props.classFields,
      'final bool isAllowed;\n'
      'final String? firstName;\n'
      'final String? name;\n'
      'final int? id;',
    );
    expect(
      props.propsBody,
      'isAllowed,\n'
      'firstName,\n'
      'name,\n'
      'id,',
    );
  });
}
