import 'package:validators/validators.dart';

class EntityGenerator {
  EntityGenerator(String jsonString) {
    if (!isJSON(jsonString)) {
      throw ArgumentError('JSON String');
    }
  }
}
