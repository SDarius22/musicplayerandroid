import 'package:audio_service/audio_service.dart';

import 'audio_provider.dart';

class NotificationProvider{
  late AudioHandler audioHandler;

  static final NotificationProvider _instance = NotificationProvider._internal();
  factory NotificationProvider() => _instance;

  NotificationProvider._internal();

  Future<void> init () async {
    audioHandler = await AudioService.init(
      builder: () => AudioProvider(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.musicplayerandroid.channel.audio',
        androidNotificationChannelName: 'Music Player',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }

  Future<void> play() async {
    await audioHandler.play();
  }

  Future<void> pause() async {
    await audioHandler.pause();
  }

  Future<void> skipToNext() async {
    await audioHandler.skipToNext();
  }

  Future<void> skipToPrevious() async {
    await audioHandler.skipToPrevious();
  }

  Future<void> stop() async {
    await audioHandler.stop();
  }
}