abstract class Description {
  final String name;
  final String type;

  Description(this.name, this.type);

  @override
  operator ==(o) => o is Description && o != null && o.name == name;

  @override
  int get hashCode => name.hashCode;

  String get generatedCode;

  Set<Description> get dependencies;
}

class SingleDescription extends Description {
  final String Function(String name, String type) gen;

  SingleDescription(String name, String type, this.gen) : super(name, type);

  @override
  String get generatedCode => gen(name, type);

  @override
  String toString() {
    return '[$type] $name';
  }

  @override
  Set<Description> get dependencies => Set.identity();
}

class ArrayDescription extends Description {
  final Description child;
  final String Function(Description child) generate;

  ArrayDescription(String name, this.child, this.generate)
      : super(name, child.type);
  @override
  String toString() {
    return '[Array<$type>] $name';
  }

  @override
  String get generatedCode => generate(child);

  @override
  Set<Description> get dependencies =>
      child is ObjectDescription ? Set.of([child]): Set.identity();
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
  Set<Description> get dependencies => children
      .takeWhile((child) =>
          child is ObjectDescription ||
          (child is ArrayDescription && child.child is ObjectDescription))
      .toSet();

  @override
  String get generatedCode => generate(children, name, type);
}
