import 'parser/yaml_parser.dart';

class QueryConverter {
  static String convert(List<MapEntry<String, String>> entries) {
    return entries.map((mapEntry) {
      final res = YamlParser.parse(mapEntry.key, mapEntry.value);
      var str = '${res.className}:${res.name}';
      if (res.key != null) {
        str += '/name';
      }
      if (res.defaultValue != null) {
        str += '=${res.defaultValue}';
      }
      return str;
    }).join(',');
  }
}