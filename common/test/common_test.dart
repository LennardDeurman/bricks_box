import 'package:flutter_test/flutter_test.dart';

import 'package:common/common.dart';

void main() {
  test('Test output', () {
    const test = 'String?:name=Lennard,int?:id=0,bool:isAllowed';
    final props = ModelPropertiesParser(test).parse();
    expect(props, isNotNull);
    expect(props!.constructorBody, 'this.name, this.id, this.isAllowed');
    expect(props.classFields, 'final String? name;\nfinal int? id;\nfinal bool isAllowed;');
    expect(props.propsBody, 'name,\nid,\nisAllowed');
  });
}
