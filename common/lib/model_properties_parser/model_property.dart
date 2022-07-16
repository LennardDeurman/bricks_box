class ModelProperty {
  final bool isOptional;
  final String? defaultValue;
  final String type;
  final String name;

  const ModelProperty({
    required this.isOptional,
    required this.name,
    this.defaultValue,
    required this.type,
  });

}
