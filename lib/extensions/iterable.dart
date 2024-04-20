import 'package:toxic/extensions/map.dart';

extension TIterable<T> on Iterable<T> {
  T? get firstOr => isEmpty ? null : first;

  Iterable<T> get unique => toSet();

  T? select(bool Function(T) test) => where(test).firstOrNull;

  T? selectLast(bool Function(T) test) => where(test).lastOrNull;

  Iterable<T> get notNull => where((element) => element != null);

  Iterable<T> add(T element) sync* {
    yield* this;
    yield element;
  }

  Iterable<T> addAll(Iterable<T> elements) sync* {
    yield* this;
    yield* elements;
  }

  Iterable<T> addFirst(T element) sync* {
    yield element;
    yield* this;
  }

  Iterable<T> addAllFirst(Iterable<T> elements) sync* {
    yield* elements;
    yield* this;
  }

  T? get mostCommon =>
      occurrences().sortedKeysByValue((a, b) => b.compareTo(a)).firstOrNull;

  /// Returns a new [Map] with the number of occurrences of each element.
  Map<T, int> occurrences() {
    Map<T, int> map = {};

    for (T e in this) {
      if (map.containsKey(e)) {
        map[e] = map[e]! + 1;
      } else {
        map[e] = 1;
      }
    }
    return map;
  }

  /// Returns a new [List] with deduplicated elements.
  List<T> deduplicatedList() {
    List<T> list = [];
    for (T e in this) {
      if (!list.contains(e)) {
        list.add(e);
      }
    }
    return list;
  }

  /// Returns a new [Iterable] with deduplicated elements.
  Iterable<T> deduplicated() sync* {
    Set<T> set = {};
    for (T e in this) {
      if (!set.contains(e)) {
        set.add(e);
        yield e;
      }
    }
  }

  /// Returns a new [List] with shuffled elements.
  List<T> shuffledList() {
    List<T> list = toList();
    list.shuffle();
    return list;
  }

  /// Returns a new [Iterable] with shuffled elements.
  Iterable<T> shuffled() sync* {
    List<T> list = toList();
    list.shuffle();
    for (T e in list) {
      yield e;
    }
  }

  Map<M, List<T>> groupBy<M>(M Function(T) grouper) {
    Map<M, List<T>> map = {};

    for (final T k in this) {
      M t = grouper(k);

      if (!map.containsKey(t)) {
        map[t] = [];
      }

      map[t]!.add(k);
    }

    return map;
  }

  /// Returns the last index of the iterable.
  int get lastIndex => length - 1;

  /// Returns the middle index of the iterable.
  int get middleIndex => length ~/ 2;

  /// Returns the middle element of the iterable.
  T? middleValue() => isEmpty ? null : elementAt(middleIndex);

  /// Returns a new [List] with reversed elements.
  List<T> reversedList() {
    List<T> list = toList();
    list.reversed;
    return list;
  }

  /// Returns a new [Iterable] with reversed elements.
  Iterable<T> reversed() sync* {
    List<T> list = toList();
    for (int i = list.length - 1; i >= 0; i--) {
      yield list[i];
    }
  }

  /// Weaves two iterables together into a new [Iterable] alternating elements.
  Iterable<T> weave(Iterable<T> other) sync* {
    bool switcher = true;
    Iterator<T> it1 = iterator;
    Iterator<T> it2 = other.iterator;
    bool hasNext1 = it1.moveNext();
    bool hasNext2 = it2.moveNext();

    while (hasNext1 || hasNext2) {
      if (switcher && hasNext1) {
        yield it1.current;
        hasNext1 = it1.moveNext();
      } else if (hasNext2) {
        yield it2.current;
        hasNext2 = it2.moveNext();
      } else if (hasNext1) {
        yield it1.current;
        hasNext1 = it1.moveNext();
      }
      switcher = !switcher;
    }
  }

  /// Returns a new [List] with sorted elements.
  List<T> sorted([int Function(T, T)? compare]) {
    List<T> list = toList();
    list.sort(compare);
    return list;
  }

  /// Returns a new [Map] where the values are used as keys in a map.
  Map<T, R> asKeys<R>(R Function(T) f) =>
      Map.fromEntries(map((e) => MapEntry(e, f(e))));

  /// Returns a new [Map] where the values are used as values in a map.
  Map<R, T> asValues<R>(R Function(T) f) =>
      Map.fromEntries(map((e) => MapEntry(f(e), e)));

  /// Returns a new [List] with mapped elements.
  List<R> mapList<R>(R Function(T) f) => map(f).toList();

  /// Returns a new [List] with mapped elements that are not null.
  List<R> softMapList<R>(R? Function(T) f) => softMap(f).toList();

  /// Returns a new [Iterable] with mapped elements that are not null.
  Iterable<R> softMap<R>(R? Function(T) f) sync* {
    for (var e in this) {
      R? r = f(e);
      if (r != null) {
        yield r;
      }
    }
  }

  T reduceOr(T or, T Function(T, T) combine) {
    if (isEmpty) {
      return or;
    }
    return reduce(combine);
  }
}
