import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    Timer(Duration(milliseconds: milliseconds), action);
  }
}