extension IterableIterableExtension<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() {
    return expand((element) => element);
  }
}
