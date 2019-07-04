abstract class Description {
  final String name;
  final String type;

  Description(this.name, this.type);

  @override
  operator ==(o) => o is Description && o != null && o.name == name;

  @override
  int get hashCode => name.hashCode;

  String get generatedCode;
}

class SimpleDescription extends Description {
  final String Function(String name, String type) gen;

  SimpleDescription(String name, String type, this.gen) : super(name, type);

  @override
  String get generatedCode => gen(name, type);

  @override
  String toString() {
    return '[$type] $name';
  }
}

class ArrayDescription extends SimpleDescription {
  ArrayDescription(
      String name, String type, String Function(String name, String type) gen)
      : super(name, type, gen);
  @override
  String toString() {
    return '[Array<$type>] $name';
  }
}

class ObjectDescription extends Description {
  final Set<Description> children;
  final String Function(Set<Description> children, String name, String type)
      generate;

  ObjectDescription(String name, String type, this.children, this.generate)
      : super(name, type);

  @override
  String toString() {
    return '[$type] $name {${children.join(', ')}}';
  }

  @override
  String get generatedCode => generate(children, name, type);
}
