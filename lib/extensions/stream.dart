import 'package:flutter/widgets.dart';

extension XStream<T> on Stream<T> {
  Stream<T> get unique => distinct();

  StreamBuilder<T> build(Widget Function(T) builder, {Widget? loading}) =>
      StreamBuilder<T>(
        stream: this,
        builder: (context, snap) => snap.hasData
            ? builder(snap.data!)
            : loading ?? const SizedBox.shrink(),
      );

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
