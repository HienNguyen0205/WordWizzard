import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordwizzard/constants/constants.dart';

class TtsController {
  static final TtsController _instance = TtsController._internal();
  late FlutterTts tts = FlutterTts();
  bool isSpeaking = false;

  factory TtsController() {
    return _instance;
  }

  Future<void> speak(String text) async {

    await tts.awaitSpeakCompletion(true);

    tts.setStartHandler(() {
      debugPrint("Playing");
    });

    tts.setCompletionHandler(() {
      debugPrint("Completed");
    });

    tts.setCancelHandler(() {
      debugPrint("Cencel");
    });

    tts.setErrorHandler((message) {
      debugPrint("Error: $message");
    });

    if (isSpeaking) {
      await stop();
    }
    isSpeaking = true;
    await tts.setLanguage("en-US");
    if(Platform.isIOS){
      await tts.setSharedInstance(true);
      await tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
          ],
          IosTextToSpeechAudioMode.defaultMode);
    }
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

  TtsController._internal();
}