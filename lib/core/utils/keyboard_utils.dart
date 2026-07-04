import 'dart:io';
import 'package:flutter/services.dart';

class KeyboardUtils {
  static const _channel = MethodChannel('tack/keyboard');

  static Future<void> configureTabletKeyboard() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('configureTabletKeyboard');
    } catch (_) {}
  }
}
