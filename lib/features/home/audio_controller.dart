import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  AudioPlayer? musicPlayer;
  bool isAudioPlaying = false;
  Timer? _segmentTimer;

  /// Play audio segment from [start] to [end]
  void startAudioSegment(String file, {required Duration start, required Duration end}) async {
    musicPlayer ??= AudioPlayer();

    await musicPlayer!.setAsset("assets/ringtone/$file");

    // Seek to start position
    await musicPlayer!.seek(start);

    // Play audio
    musicPlayer!.play();
    isAudioPlaying = true;

    // Stop after the segment duration
    _segmentTimer?.cancel();
    _segmentTimer = Timer(end - start, () {
      stopAudio();
    });
  }

  void stopAudio() {
    _segmentTimer?.cancel();
    if (musicPlayer != null && isAudioPlaying) {
      musicPlayer!.stop();
      isAudioPlaying = false;
    }
  }

  @override
  void onClose() {
    stopAudio();
    musicPlayer?.dispose();
    super.onClose();
  }
}
