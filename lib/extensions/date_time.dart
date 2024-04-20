extension XDateTime on DateTime {
  bool isSameDayAs(DateTime dt) =>
      year == dt.year && month == dt.month && day == dt.day;

  int get ms => millisecondsSinceEpoch;
}
