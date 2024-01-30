extension IterableExtensions<E> on Iterable<E> {
  Iterable<E> intersperse(E Function(E previous, E next) generator) sync* {
    final iterator = this.iterator;
    late E previous;

    if (iterator.moveNext()) {
      previous = iterator.current;
      yield previous;
    }

    while (iterator.moveNext()) {
      final current = iterator.current;

      yield generator(previous, current);

      yield current;
      previous = current;
    }
  }
}

extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() {
    return expand((element) => element);
  }
}

extension ListExtension<E> on Iterable<E> {
  List<E> setLength(int newLength, E Function(int index) generator) {
    return [
      ...take(newLength),
      for (var i = length; i < newLength; i++) //
        generator(i),
    ];
  }
}
