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
