extension TIterableFuture<T> on Iterable<Future<T>> {
  Future<List<T>> wait() => Future.wait(this);
}
