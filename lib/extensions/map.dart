import 'package:toxic/toxic.dart';

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

  Map<K, V> remap((K key, V value)? Function(MapEntry<K, V>) remapper) {
    Map<K, V> map = {};
    for (MapEntry<K, V> entry in entries) {
      (K key, V value)? newEntry = remapper(entry);
      if (newEntry != null) {
        map[newEntry.$1] = newEntry.$2;
      }
    }
    return map;
  }

  K? firstKeyWhere(bool Function(V) test) => keysWhere(test).firstOrNull;

  Iterable<K> keysWhere(bool Function(V) test) =>
      entries.where((p) => test(p.value)).map((p) => p.key);

  V? firstValueWhere(bool Function(K) test) => valuesWhere(test).firstOrNull;

  Iterable<V> valuesWhere(bool Function(K) test) =>
      entries.where((p) => test(p.key)).map((p) => p.value);

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
