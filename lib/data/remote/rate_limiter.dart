class RateLimiter {
  RateLimiter({required this.maxPerMinute});

  final int maxPerMinute;
  final List<DateTime> _times = [];

  bool tryAcquire() {
    final now = DateTime.now();
    _times.removeWhere((t) => now.difference(t) > const Duration(minutes: 1));
    if (_times.length >= maxPerMinute) return false;
    _times.add(now);
    return true;
  }
}

class RateLimitedException implements Exception {
  @override
  String toString() => 'Rate limited';
}
