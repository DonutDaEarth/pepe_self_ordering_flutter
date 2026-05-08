import 'dart:math' as math;

String formatPrice(int value) {
  final s = value.toString();
  final chunks = <String>[];
  for (int i = s.length; i > 0; i -= 3) {
    chunks.insert(0, s.substring(math.max(0, i - 3), i));
  }
  return chunks.join('.');
}
