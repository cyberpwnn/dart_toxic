import 'dart:collection';
import 'dart:math';

/// An object pool that can allow reuse of objects.
/// A pooled object must add the mixin [Pooled] to work with this pool.
/// You can define the [minAvailable] and [growthFactor] to control the pool size.
/// The [growthFactor] is a multiplier on the inUse count.
/// So if 100 are in use with a growth factor of 0.15, the pool will maintain
/// 15 available objects.
///
/// By default [batchedGrowth] is enabled which means that the pool will only
/// grow when there are no available objects. If you disable this, the pool will
/// grow every time you take an object, essentially double allocating whenever a new object
/// is needed on top of the existing inUse objects. Batched growth is better for GC however
/// if you need low latency and can afford the added new-pressure you can disable it.
class Pool<T extends Pooled> {
  final Set<T> _available;
  final Set<T> _inUse;
  final T Function() factory;
  final int minAvailable;
  final double growthFactor;
  final bool batchedGrowth;

  Pool({
    required this.factory,
    this.minAvailable = 1,
    this.growthFactor = 0.15,
    this.batchedGrowth = true,
  })  : _available = new HashSet.identity(),
        _inUse = new HashSet.identity();

  /// Gets the count of objects currently available
  int get availableCount => _available.length;

  /// Gets the count of objects in use
  int get inUseCount => _inUse.length;

  void _grow() {
    if (availableCount > 0) {
      return;
    }

    final targetSize = max(inUseCount * growthFactor, minAvailable);
    while (availableCount < targetSize) {
      _available.add(factory()
        .._pool = this
        ..onReset());
    }
  }

  /// Takes from the available set of objects without attempting to grow, will throw
  /// an exception if no objects are available instead of growing.
  T get takeNow {
    if (_available.isEmpty) {
      throw Exception('No objects available!');
    }

    final t = _available.first;
    if (!_available.remove(t)) {
      throw Exception('Trying to take an object that is not available!');
    }

    if (!_inUse.add(t)) {
      throw Exception('Trying to take an object that is already in use!');
    }

    return t;
  }

  /// Grows the pool availability if needed then takes an available object from the pool
  T get take {
    _grow();
    return takeNow;
  }

  void release(T t) {
    if (!_inUse.remove(t)) {
      throw Exception('Trying to release an object that is not in use!');
    }

    t.onReset();
    if (!_available.add(t)) {
      throw Exception('Trying to release an object that is already available!');
    }
  }
}

/// Represents a pooled object. Implement onReset for objects being added back to the pool
/// to reset any fields before being reused.
mixin Pooled {
  late Pool _pool;

  /// Called by the pool when an object is being added to the available set in the pool
  void onReset();

  /// Releases this object back into the available set in the pool it came from.
  /// This method can only be called if it was taken from a pool. After releasing this object,
  /// it could be used & modified by another user of the pool so treat this as a dispose
  void release() => _pool.release(this);
}
