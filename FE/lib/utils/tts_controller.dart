import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordwizzard/constants/constants.dart';

class TtsController {
  static final TtsController _instance = TtsController._internal();
  FlutterTts tts = FlutterTts();
  bool isSpeaking = false;

  Future<void> speak(String text) async {
    if (isSpeaking) {
      await stop();
    }
    isSpeaking = true;
    await tts.setVolume(volume);
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);
    await tts.speak(text);
    isSpeaking = false;
  }

  Future<void> stop() async {
    await tts.stop();
    isSpeaking = false;
  }

  factory TtsController() {
    return _instance;
  }

  TtsController._internal();
}