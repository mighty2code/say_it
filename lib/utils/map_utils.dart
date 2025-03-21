class MapUtils {
  static Map<String, dynamic> rawMapToMapStringDynamic(Object? object) {
    if(object is! Map<Object?, Object?>) return {};
    return object.map((key, val) => MapEntry(key.toString(), val));
  }
}