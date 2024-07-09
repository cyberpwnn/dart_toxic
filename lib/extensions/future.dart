extension TFuture<T> on Future<T> {
  Future<X> thenWait<X>(Future<X> next) => then((_) => next);

  Future<T> thenRun(void Function(T value) action) {
    return then((value) {
      action(value);
      return value;
    });
  }
}

extension TNFuture<T> on Future<T?> {
  Future<T> get bang => then((value) => value!);
  Future<T> or(T fallback) => then((value) => value ?? fallback);
}
