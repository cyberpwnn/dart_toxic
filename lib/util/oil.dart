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
