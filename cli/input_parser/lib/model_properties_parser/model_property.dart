class ModelProperty implements Comparable<ModelProperty> {
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

  int get orderIndex {
    final isRequired = !isOptional;
    final hasNoDefault = defaultValue == null;
    if (isRequired) {
      return 1;
    } else if (hasNoDefault) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  int compareTo(ModelProperty other) {
    return orderIndex.compareTo(other.orderIndex);
  }

}
