import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SoundManager {
  AudioPlayer audioPlayer = AudioPlayer();
  Future playLocal(String localFileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$localFileName');
    if (!file.existsSync()) {
      final soundData = await rootBundle.load('assets/sounds/$localFileName');
      final bytes = soundData.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
    }
    await audioPlayer.play(file.path, isLocal: true);
  }

  Future<int> getCurrentPosition() async {
      return await audioPlayer.getCurrentPosition();
  }

  Future resumeSound() async {
    await audioPlayer.resume();
  }

  Future pauseSound() async {
    await audioPlayer.pause();
  }

  Future stopSound() async {
    await audioPlayer.stop();
  }
}