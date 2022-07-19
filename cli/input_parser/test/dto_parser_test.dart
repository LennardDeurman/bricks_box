import 'package:test/test.dart';
import 'package:input_parser/dto_properties_parser/dto_properties_parser.dart';

void main() {
  test('Test output', () {
    const test =
        'String?:name/name=Lennard,int?:id/account_id=0,bool:isAllowed/is_allowed,String?:firstName/first_name';
    final props = DtoPropertiesParser(test).parse();
    expect(props, isNotNull);
    expect(props!.constructorBody,
        '{required this.isAllowed, this.firstName, required this.name, required this.id,}');
    expect(
        props.classFields,
        '@JsonKey(name: \'is_allowed)\';\n'
        'final bool isAllowed;\n'
        '@JsonKey(name: \'first_name)\';\n'
        'final String? firstName;\n'
        '@JsonKey(name: \'name\', defaultValue: Lennard);\n'
        'final String? name;\n'
        '@JsonKey(name: \'account_id\', defaultValue: 0);\n'
        'final int? id;');
    expect(
      props.propsBody,
      'isAllowed,\n'
      'firstName,\n'
      'name,\n'
      'id,',
    );
  });
}
