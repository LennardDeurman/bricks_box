class ParsedField {
  final String name;
  final String className;
  final bool isOptional;
  final String? defaultValue;
  final String? key;

  const ParsedField({
    required this.name,
    required this.className,
    required this.isOptional,
    this.defaultValue,
    this.key,
  });
}
