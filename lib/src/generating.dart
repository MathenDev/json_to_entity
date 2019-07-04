import 'description.dart';

abstract class Generating {
  Description _description;

  Generating(String name, json) {
    _description = _generate(name, json);
  }

  Description _generate(String key, value) {
    if (value is Map<String, dynamic>) {
      return ObjectDescription(
          key,
          key.substring(0, 1).toUpperCase() + key.substring(1),
          value.entries.map((e) => _generate(e.key, e.value)).toSet(),
          generateCodeObject);
    }
    if (value is List) {
      return ArrayDescription(
          key, _generate('', combineArrayElements(value)), generateCodeArray);
    }
    return SingleDescription(key, getSingleType(value), generateCodeSingle);
  }

  dynamic combineArrayElements(List values);

  String getSingleType(value);

  String generateCodeSingle(String name, String type);

  String generateCodeArray(Description child);

  String generateCodeObject(
      Set<Description> children, String name, String type);

  Description get description => _description;
}
