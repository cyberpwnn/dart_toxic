import 'package:toxic/toxic.dart';

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

  List<double> get ascending => sorted((a, b) => a.compareTo(b));

  List<double> get descending => sorted((a, b) => b.compareTo(a));

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
