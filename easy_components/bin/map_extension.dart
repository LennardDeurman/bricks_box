extension MapExtension on Map {
  T get<T>(String key, T defaultValue) {
    final hasField = containsKey(key);
    if (hasField) return this[key] ?? defaultValue;
    return defaultValue;
  }
}
