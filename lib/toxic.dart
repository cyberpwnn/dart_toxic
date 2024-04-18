library toxic;

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

final Random _random = Random();
final NumberFormat _f = NumberFormat("#,##0");

randomBool() => _random.nextBool();

randomDouble() => _random.nextDouble();

extension XRandom on Random {
  String nextString(int length,
      {String charset =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"}) {
    return String.fromCharCodes(Iterable.generate(
        length, (_) => charset.codeUnitAt(_random.nextInt(charset.length))));
  }
}

extension XFloat64List on Float64List {
  Offset transformOffset(Offset point) {
    return Offset(
      (this[0] * point.dx) + (this[4] * point.dy) + this[12],
      (this[1] * point.dx) + (this[5] * point.dy) + this[13],
    );
  }

  Rect transformRect(Rect rect) {
    final Offset topLeft = transformOffset(rect.topLeft);
    final Offset topRight = transformOffset(rect.topRight);
    final Offset bottomLeft = transformOffset(rect.bottomLeft);
    final Offset bottomRight = transformOffset(rect.bottomRight);

    double left =
        [topLeft.dx, topRight.dx, bottomLeft.dx, bottomRight.dx].reduce(min);
    double right =
        [topLeft.dx, topRight.dx, bottomLeft.dx, bottomRight.dx].reduce(max);
    double top =
        [topLeft.dy, topRight.dy, bottomLeft.dy, bottomRight.dy].reduce(min);
    double bottom =
        [topLeft.dy, topRight.dy, bottomLeft.dy, bottomRight.dy].reduce(max);

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Float64List get inverted {
    double a = this[0];
    double b = this[1];
    double c = this[4];
    double d = this[5];
    double tx = this[12];
    double ty = this[13];

    double det = a * d - b * c;
    if (det == 0) {
      throw Exception('Matrix cannot be inverted because it is singular');
    }

    double invertedA = d / det;
    double invertedB = -b / det;
    double invertedC = -c / det;
    double invertedD = a / det;
    double invertedTx = (c * ty - d * tx) / det;
    double invertedTy = (b * tx - a * ty) / det;

    final Float64List invertedMatrix = Float64List(16);

    invertedMatrix[0] = invertedA;
    invertedMatrix[1] = invertedB;
    invertedMatrix[4] = invertedC;
    invertedMatrix[5] = invertedD;
    invertedMatrix[12] = invertedTx;
    invertedMatrix[13] = invertedTy;

    invertedMatrix[10] = 1;
    invertedMatrix[15] = 1;

    return invertedMatrix;
  }

  Float64List scaled(double x, double y) {
    final Float64List copy = Float64List.fromList(this);

    copy[0] *= x;
    copy[1] *= x;
    copy[4] *= y;
    copy[5] *= y;

    return copy;
  }

  Float64List translated(double x, double y) {
    final Float64List copy = Float64List.fromList(this);

    copy[12] += x;
    copy[13] += y;

    return copy;
  }

  void applyToCanvas(Canvas canvas) {
    canvas.restoreToCount(0);
    canvas.transform(this);
  }

  double get translationX => this[12];

  double get translationY => this[13];

  Offset get translation => Offset(translationX, translationY);

  double get scaleX => this[0];

  double get scaleY => this[5];

  Offset get scale => Offset(scaleX, scaleY);

  double get rotation {
    double cosTheta = this[0];
    double sinTheta = this[1];

    return atan2(sinTheta, cosTheta);
  }
}

extension XIterableOffset on Iterable<Offset> {
  Rect toRect() {
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (Offset offset in this) {
      minX = min(minX, offset.dx);
      minY = min(minY, offset.dy);
      maxX = max(maxX, offset.dx);
      maxY = max(maxY, offset.dy);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}

extension XIterableRect on Iterable<Rect> {
  Rect toRect() {
    if (isEmpty) {
      return Rect.zero;
    }

    if (length == 1) {
      return first;
    }

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (Rect rect in this) {
      minX = min(minX, rect.left);
      minY = min(minY, rect.top);
      maxX = max(maxX, rect.right);
      maxY = max(maxY, rect.bottom);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }
}

extension XRect on Rect {
  bool fullyContains(Rect other) {
    return contains(other.topLeft) &&
        contains(other.topRight) &&
        contains(other.bottomLeft) &&
        contains(other.bottomRight);
  }

  Rect remap(Offset Function(Offset point)? remapper) => [
        remapper?.call(topLeft) ?? topLeft,
        remapper?.call(topRight) ?? topRight,
        remapper?.call(bottomRight) ?? bottomRight,
        remapper?.call(bottomLeft) ?? bottomLeft,
      ].toRect();

  /// Returns a new [Rect] if the current [Rect] is outside the [withinBounds]
  /// otherwise returns null. If the [Rect] is outside the [withinBounds] it will
  /// be adjusted to fit within the [withinBounds] maintaining the aspect ratio.
  Rect? constrain(Rect withinBounds) {
    double aspectRatio = withinBounds.width / withinBounds.height;

    double width = this.width;
    double height = this.height;
    double left = this.left;
    double top = this.top;
    bool needsAdjustment = false;

    if (width > withinBounds.width) {
      width = withinBounds.width;
      height = width / aspectRatio;
      needsAdjustment = true;
    } else if (height > withinBounds.height) {
      height = withinBounds.height;
      width = height * aspectRatio;
      needsAdjustment = true;
    }

    if (left < withinBounds.left) {
      left = withinBounds.left;
      needsAdjustment = true;
    } else if (top < withinBounds.top) {
      top = withinBounds.top;
      needsAdjustment = true;
    } else if (left + width > withinBounds.right) {
      left = withinBounds.right - width;
      needsAdjustment = true;
    } else if (top + height > withinBounds.bottom) {
      top = withinBounds.bottom - height;
      needsAdjustment = true;
    }

    return needsAdjustment ? Rect.fromLTWH(left, top, width, height) : null;
  }

  Rect inflatePercent(double percent) => Rect.fromCenter(
      center: center,
      width: width + (width * percent),
      height: height + (height * percent));

  Rect deflatePercent(double percent) => deflate(maxSide * percent);

  double get maxSide => max(width, height);

  double get minSide => min(width, height);
}

extension XPath on Path {
  void move(Offset offset) => moveTo(offset.dx, offset.dy);

  void line(Offset offset) => lineTo(offset.dx, offset.dy);
}

extension XColor on Color {
  String get hex => "#${value.toRadixString(16).padLeft(8, '0').substring(2)}";

  String get hexRGB =>
      "#${value.toRadixString(16).padLeft(8, '0').substring(6)}";
}

extension XSize on Size {
  Offset get asOffset => Offset(width, height);

  Rect toRect([Offset? offset]) => Rect.fromCenter(
      center: offset ?? Offset.zero, width: width, height: height);

  Size operator /(double factor) => Size(width / factor, height / factor);

  Size operator *(double factor) => Size(width * factor, height * factor);
}

extension XOffset on Offset {
  Size get asSize => Size(dx, dy);

  double distanceSquaredTo(Offset point) {
    double l2 = (this - point).distanceSquared;
    return l2;
  }

  Offset scalarMultiply(double scalar) => Offset(dx * scalar, dy * scalar);

  double dot(Offset other) => dx * other.dx + dy * other.dy;

  Offset flipY() => Offset(dx, -dy);

  Offset flipX() => Offset(-dx, dy);
}

extension XObject on Object {
  int get identityHash => identityHashCode(this);
}

extension FileFormatter on num {
  String readableFileSize({bool base1024 = true}) {
    final base = base1024 ? 1024 : 1000;
    if (this <= 0) return "0";
    final units = ["B", "KB", "MB", "GB", "TB", "PB"];
    int digitGroups = 0;

    if (this > base) {
      digitGroups = 1;
    }

    if (this > pow(base, 2)) {
      digitGroups = 2;
    }

    if (this > pow(base, 3)) {
      digitGroups = 3;
    }

    if (this > pow(base, 4)) {
      digitGroups = 4;
    }

    if (this > pow(base, 5)) {
      digitGroups = 5;
    }

    return "${_f.format(this / pow(base, digitGroups))} ${units[digitGroups]}";
  }
}

extension TDouble on double {
  double centerOnBit(int bitDepth) =>
      ((floor() >> bitDepth) << bitDepth) + (1 << (bitDepth - 1)).toDouble();

  double roundToNearest(int decimal) => (this * decimal).round() / decimal;

  double get deg => this * 180 / pi;

  double get rad => this * pi / 180;

  String percent([int decimals = 0]) =>
      "${(this * 100).toStringAsFixed(decimals)}%";

  String format([NumberFormat? f]) =>
      (f ?? NumberFormat.decimalPattern()).format(this);

  String get formatCompact => NumberFormat.compact().format(this);

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
  String get lowerCamelCaseToUpperSpacedCase =>
      replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
          .trim()
          .capitalizeWords();

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

extension XDateTime on DateTime {
  bool isSameDayAs(DateTime dt) =>
      year == dt.year && month == dt.month && day == dt.day;
}

extension XStream<T> on Stream<T> {
  StreamBuilder<T> build(Widget Function(T) builder, {Widget? loading}) =>
      StreamBuilder<T>(
        stream: this,
        builder: (context, snap) => snap.hasData
            ? builder(snap.data!)
            : loading ?? const SizedBox.shrink(),
      );
}

extension TFuture<T> on Future<T> {
  Future<T> thenRun(void Function(T value) action) {
    return then((value) {
      action(value);
      return value;
    });
  }

  FutureBuilder<Widget> build(Widget Function(T) builder, {Widget? loading}) =>
      FutureBuilder<Widget>(
        future: then(builder),
        builder: (context, snap) =>
            snap.hasData ? snap.data! : loading ?? const SizedBox.shrink(),
      );
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

extension TIterableFuture<T> on Iterable<Future<T>> {
  Future<List<T>> wait() => Future.wait(this);
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

  int sum() => isEmpty
      ? 0
      : length == 1
          ? first
          : fold(0, (previousValue, element) => previousValue + element);

  int product() => fold(1, (previousValue, element) => previousValue * element);

  int min() =>
      reduceOr(0, (value, element) => value < element ? value : element);

  int max() =>
      reduceOr(0, (value, element) => value > element ? value : element);

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

  double sum() => isEmpty
      ? 0
      : length == 1
          ? first
          : fold(0, (previousValue, element) => previousValue + element);

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
  List<T> shuffle([Random? random]) {
    random ??= Random();
    List<T> list = [];

    while (isNotEmpty) {
      list.add(popRandom(random));
    }

    return list;
  }

  int randomIndex([Random? random]) {
    random ??= Random();
    return random.nextInt(length);
  }

  T popRandom([Random? random]) => removeAt(randomIndex(random));

  List<T> toBack(T element) {
    if (remove(element)) {
      add(element);
    }

    return this;
  }

  List<T> toFront(T element) {
    if (remove(element)) {
      insert(0, element);
    }

    return this;
  }

  List<T> toBackWhere(bool Function(T) test) {
    int at = indexWhere(test);

    if (at != -1) {
      T element = removeAt(at);
      add(element);
    }

    return this;
  }

  List<T> toFrontWhere(bool Function(T) test) {
    int at = indexWhere(test);

    if (at != -1) {
      T element = removeAt(at);
      insert(0, element);
    }

    return this;
  }

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

Future<void> _nextTick() => Future.delayed(Duration.zero);

class Oil {
  final bool warnings;
  final double blockTime;
  int _p = 0;
  int lastTime = 0;
  int blocks = 0;

  Oil({this.blockTime = 16.666666666666668, this.warnings = false});

  Future<void> wait(String note) async {
    _p = DateTime.now().millisecondsSinceEpoch;
    if (_p - lastTime >= blockTime) {
      if (warnings && _p - lastTime >= blockTime * 2) {
        print(
            "Block #$blocks [$note] took too long to complete: ${_p - lastTime}ms");
      }

      await _nextTick();
      lastTime = DateTime.now().millisecondsSinceEpoch;
      blocks++;
    }
  }
}

BehaviorSubject<String> _signalStream = BehaviorSubject<String>();

void signal(String signal) => _signalStream.add(signal);

StreamSubscription<String> onSignal(String signal, void Function() callback) =>
    _signalStream
        .where((event) => event == signal)
        .listen((event) => callback());

Widget buildOnSignal(String signal, WidgetBuilder builder) =>
    StreamBuilder<String>(
      stream: _signalStream.where((event) => event == signal),
      builder: (context, _) => builder(context),
    );

class SignalBuilder extends StatelessWidget {
  final String signal;
  final WidgetBuilder builder;

  const SignalBuilder({super.key, required this.signal, required this.builder});

  @override
  Widget build(BuildContext context) => StreamBuilder<String>(
        stream: _signalStream.where((event) => event == signal),
        builder: (context, _) => builder(context),
      );
}

Widget provide<T>(T value, Widget widget) =>
    Provider<T>.value(value: value, child: widget);

Widget provide2<T, U>(T value1, U value2, Widget widget) => MultiProvider(
      providers: [
        Provider<T>.value(value: value1),
        Provider<U>.value(value: value2),
      ],
      child: widget,
    );

Widget provide3<T, U, V>(T value1, U value2, V value3, Widget widget) =>
    MultiProvider(
      providers: [
        Provider<T>.value(value: value1),
        Provider<U>.value(value: value2),
        Provider<V>.value(value: value3),
      ],
      child: widget,
    );

Widget provide4<T, U, V, W>(
        T value1, U value2, V value3, W value4, Widget widget) =>
    MultiProvider(
      providers: [
        Provider<T>.value(value: value1),
        Provider<U>.value(value: value2),
        Provider<V>.value(value: value3),
        Provider<W>.value(value: value4),
      ],
      child: widget,
    );
