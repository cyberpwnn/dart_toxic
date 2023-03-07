library toxic;

import 'dart:math';

import 'package:intl/intl.dart';

extension TDouble on double {
  String percent([int decimals = 0]) =>
      "${(this * 100).toStringAsFixed(decimals)}%";

  String format([NumberFormat? f]) =>
      (f ?? NumberFormat.decimalPattern()).format(this);

  String formatCompact() => NumberFormat.compact().format(this);

  /// Lerp this, to the given value, by the given progress.
  double to(double to, double progress) => this + (to - this) * progress;
}

extension TInt on int {
  double to(num to, double progress) => this + (to - this) * progress;

  String plural(String singular, [String? plural]) =>
      this == 1 ? singular : plural ?? (singular + "s");

  String format([NumberFormat? f]) =>
      (f ?? NumberFormat.decimalPattern()).format(this);

  String formatCompact() => NumberFormat.compact().format(this);
}

extension TString on String {
  String get roadkill => replaceAll(" ", "_").toLowerCase();

  String get upperRoadkill => replaceAll(" ", "_").toUpperCase();

  String get dashkill => replaceAll(" ", "-").toLowerCase();

  String get upperDashkill => replaceAll(" ", "-").toUpperCase();

  String get camelCase =>
      split(" ").map((e) => e.toLowerCase().capitalize()).join();

  String randomCase() => charMap((e) => e == " "
      ? " "
      : Random().nextBool()
          ? e.toUpperCase()
          : e.toLowerCase());

  String charMap(String Function(String char) map) {
    String s = "";
    for (int i = 0; i < length; i++) {
      s += map(this[i]);
    }
    return s;
  }

  String get reversed => split("").reversed.join();

  List<String> splitSlashes() => split("/");

  List<String> splitDots() => split(".");

  String splitAfter(String separator, String key) {
    List<String> s = split(separator);
    int index = s.indexOf(key);
    if (index == -1 || index >= s.lastIndex) {
      return "";
    }
    return s[index + 1];
  }

  String splitLast(String separator) => split(separator).last;

  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";

  String capitalizeWords() => split(" ").map((e) => e.capitalize()).join(" ");
}

extension TFuture<T> on Future<T> {
  Future<T> thenRun(void Function(T value) action) {
    return then((value) {
      action(value);
      return value;
    });
  }
}

extension TMap<K, V> on Map<K, V> {
  Map<K, V> operator +(Map<K, V> other) => {...this, ...other};

  Map<K, V> operator -(K k) => {...this}..remove(k);

  List<V> sortedValuesByKey(int Function(K, K)? compare) {
    List<K> k = this.keys.sorted(compare);
    return List.generate(k.length, (index) => this[k[index]]!);
  }

  List<K> sortedKeysByValue(int Function(V, V)? compare) {
    List<V> v = this.values.sorted(compare);
    return List.generate(
        v.length,
        (index) =>
            this.keys.firstWhere((element) => this[element] == v[index]));
  }

  V compute(K key, V Function(K key, V? value) compute) {
    this[key] = compute(key, this[key]);
    return this[key]!;
  }

  V computeIfPresent(K key, V Function(K key, V value) ifPresent) {
    if (containsKey(key)) {
      this[key] = ifPresent(key, this[key]!);
    }
    return this[key]!;
  }

  V computeIfAbsent(K key, V Function(K key) ifAbsent) {
    if (!containsKey(key)) {
      this[key] = ifAbsent(key);
    }
    return this[key]!;
  }

  Future<V> computeIfAbsentAsync(
      K key, Future<V> Function(K key) ifAbsent) async {
    if (!containsKey(key)) {
      this[key] = await ifAbsent(key);
    }
    return this[key]!;
  }

  Future<V> computeAsync(
      K key, Future<V> Function(K key, V? value) compute) async {
    this[key] = await compute(key, this[key]);
    return this[key]!;
  }

  Future<V> computeIfPresentAsync(
      K key, Future<V> Function(K key, V value) ifPresent) async {
    if (containsKey(key)) {
      this[key] = await ifPresent(key, this[key]!);
    }
    return this[key]!;
  }

  Map<V, K> flipFlat() {
    Map<V, K> map = {};
    for (K key in keys) {
      map[this[key]!] = key;
    }
    return map;
  }

  Map<V, List<K>> flip() {
    Map<V, List<K>> map = {};
    for (K key in keys) {
      V value = this[key]!;
      if (map.containsKey(value)) {
        map[value]!.add(key);
      } else {
        map[value] = [key];
      }
    }
    return map;
  }

  Map<K, V> merge(Map<K, V> other) {
    Map<K, V> map = {};
    map.addAll(this);
    map.addAll(other);
    return map;
  }
}

extension TIterableInt on Iterable<int> {
  Iterable<int> operator *(int value) => map((e) => e * value);

  Iterable<int> operator ~/(int value) => map((e) => e ~/ value);

  Iterable<int> operator +(int value) => map((e) => e + value);

  Iterable<int> operator -(int value) => map((e) => e - value);

  Iterable<int> operator %(int value) => map((e) => e % value);

  Iterable<int> operator ^(int value) => map((e) => e ^ value);

  Iterable<int> operator |(int value) => map((e) => e | value);

  Iterable<int> operator &(int value) => map((e) => e & value);

  Iterable<int> operator <<(int value) => map((e) => e << value);

  Iterable<int> operator >>(int value) => map((e) => e >> value);

  Iterable<int> operator ~() => map((e) => ~e);

  Iterable<int> operator -() => map((e) => -e);

  int sum() => fold(0, (previousValue, element) => previousValue + element);

  int product() => fold(1, (previousValue, element) => previousValue * element);

  int min() => reduce((value, element) => value < element ? value : element);

  int max() => reduce((value, element) => value > element ? value : element);

  int averageInt() => sum() ~/ length;

  double average() => sum() / length.toDouble();

  int median() {
    List<int> list = toList();
    list.sort();
    return list[list.length ~/ 2];
  }

  int mode() {
    Map<int, int> map = occurrences();
    int max = 0;
    int mode = 0;
    for (int key in map.keys) {
      if (map[key]! > max) {
        max = map[key]!;
        mode = key;
      }
    }
    return mode;
  }
}

extension TIterableDouble on Iterable<double> {
  Iterable<double> operator *(int value) => map((e) => e * value);

  Iterable<double> operator /(int value) => map((e) => e / value);

  Iterable<double> operator +(int value) => map((e) => e + value);

  Iterable<double> operator -(int value) => map((e) => e - value);

  Iterable<double> operator %(int value) => map((e) => e % value);

  Iterable<double> operator -() => map((e) => -e);

  double sum() => fold(0, (previousValue, element) => previousValue + element);

  double product() =>
      fold(1, (previousValue, element) => previousValue * element);

  double min() => reduce((value, element) => value < element ? value : element);

  double max() => reduce((value, element) => value > element ? value : element);

  double average() => sum() / length;

  double median() {
    List<double> list = toList();
    list.sort();
    return list[list.length ~/ 2];
  }

  double mode() {
    Map<double, int> map = occurrences();
    int max = 0;
    double mode = 0;
    for (double key in map.keys) {
      if (map[key]! > max) {
        max = map[key]!;
        mode = key;
      }
    }
    return mode;
  }
}

extension TList<T> on List<T> {
  List<T> operator +(T element) {
    List<T> list = toList();
    list.add(element);
    return list;
  }

  List<T> operator -(T element) {
    List<T> list = toList();
    list.remove(element);
    return list;
  }
}

extension TSet<T> on Set<T> {
  Set<T> operator +(T element) {
    Set<T> list = toSet();
    list.add(element);
    return list;
  }

  Set<T> operator -(T element) {
    Set<T> list = toSet();
    list.remove(element);
    return list;
  }
}

extension TIterable<T> on Iterable<T> {
  T? get firstOr => isEmpty ? null : first;

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
}
