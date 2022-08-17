import 'test.models.dart';

extension MirrorTestChildMapper on MirrorTestChild {
  MirrorTestChildEntity toMirrorTestChildEntity() {
    return MirrorTestChildEntity(id: id);
  }
}
