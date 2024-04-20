import 'dart:math';

Random _r = Random();

extension TList<T> on List<T> {
  List<T> shuffle([Random? random]) {
    random ??= _r;
    List<T> list = [];

    while (isNotEmpty) {
      list.add(popRandom(random));
    }

    return list;
  }

  int randomIndex([Random? random]) {
    random ??= _r;
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
