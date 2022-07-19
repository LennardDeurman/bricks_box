abstract class Converter {

  final Map<String, dynamic> original;

  Converter(this.original);

  Map<String, dynamic> convert();

}