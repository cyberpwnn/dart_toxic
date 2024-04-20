import 'package:toxic/toxic.dart';

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

  List<int> get ascending => sorted((a, b) => a.compareTo(b));

  List<int> get descending => sorted((a, b) => b.compareTo(a));

  Iterable<int> get evens => where((element) => element.isEven);

  Iterable<int> get odds => where((element) => element.isOdd);

  Iterable<int> get primes => where((element) => element.isPrime);

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
