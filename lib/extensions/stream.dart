import 'package:rxdart/rxdart.dart';

extension XNStream<T> on Stream<T?> {
  Stream<T> get bang => map((value) => value!);
  Stream<T> or(T fallback) => map((value) => value ?? fallback);
}

extension XStream<T> on Stream<T> {
  Stream<T> get unique => distinct();

  List<Stream<dynamic>> and(Stream<dynamic> other) => [this, other];

  Future<T?> get firstOrNull => isEmpty.then((value) => value ? null : first);

  Future<T?> get lastOrNull => isEmpty.then((value) => value ? null : last);

  Future<T?> select(bool Function(T) test) => where(test).firstOrNull;

  Future<T?> selectLast(bool Function(T) test) => where(test).lastOrNull;

  Stream<List<T>> chunked(int chunkSize) async* {
    List<T> chunk = [];
    await for (T e in this) {
      chunk.add(e);
      if (chunk.length >= chunkSize) {
        yield chunk;
        chunk = [];
      }
    }

    if (chunk.isNotEmpty) {
      yield chunk;
    }
  }

  Stream<T> whereIndex(bool Function(T value, int index) test) async* {
    int i = 0;
    await for (T e in this) {
      if (test(e, i++)) {
        yield e;
      }
    }
  }

  Stream<V> mapIndexed<V>(V Function(T value, int index) f) async* {
    int i = 0;
    await for (T e in this) {
      yield f(e, i++);
    }
  }

  Stream<T> skip(int n) async* {
    int i = 0;
    await for (T e in this) {
      if (i++ >= n) {
        yield e;
      }
    }
  }
}

extension XStreamSemaphore<T> on Stream<T> {
  /// Unlike asyncMap:
  /// INPUT -> (await) MAPPER -> OUTPUT
  ///
  /// This semaphoreMap does:
  /// INPUT -> (accumulate bufferSize) -> EXPAND Future.wait(buffer.map(MAPPER)) -> OUTPUT
  ///
  /// The semaphoreMap is still completed in order, but the buffer size is used to limit the number of concurrent operations.
  /// Instead of 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20 (commas where waiting)
  /// It will do 1234,5678,9101112,13141516,17181920 (commas where waiting)
  Stream<V> semaphoreMap<V>(int bufferSize, Future<V> Function(T t) mapper) =>
      accumulateBy(
        bufferSize,
        (i) => 1,
      ).asyncMap((i) => Future.wait(i.map(mapper))).expand((i) => i);

  /// Unlike asyncMap and semaphoreMap: the order of the output is not guaranteed.
  /// As soon as a Future is completed, it is yielded.
  /// Once all Futures are completed, the Stream is completed.
  Stream<V> parallelMap<V>(Future<V> Function(T t) mapper) async* {
    List<Future<V>> work = [];
    BehaviorSubject<V> emit = BehaviorSubject();

    await for (T i in this) {
      Future<V> job = mapper(i);
      work.add(job);
      job.then(emit.add);
    }

    Future closer = emit.close();
    yield* emit.stream;
    await closer;
    await Future.wait(work);
  }
}

extension XStreamAcc<T> on Stream<T> {
  Stream<List<T>> accumulateBy(
    int limit,
    int Function(T) weigher, {
    int? maxAmount,
  }) async* {
    List<T> buffer = [];
    int size = 0;

    await for (T chunk in this) {
      if (maxAmount != null && buffer.length >= maxAmount) {
        yield buffer;
        buffer = [];
        size = 0;
      }

      int weight = weigher(chunk);

      if (size + weight > limit) {
        if (buffer.isNotEmpty) {
          yield buffer;
          buffer = [];
          size = 0;
        } else {
          yield [chunk];
          buffer = [];
          size = 0;
        }
      }

      buffer.add(chunk);
      size += weight;
    }

    if (buffer.isNotEmpty) {
      yield buffer;
    }
  }
}
