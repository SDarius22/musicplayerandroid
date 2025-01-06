import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/controller/app_manager.dart';
import 'package:musicplayerandroid/controller/settings_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends BaseAudioHandler with SeekHandler {
  static final AudioPlayerController _instance = AudioPlayerController._internal();

  factory AudioPlayerController() => _instance;

  AudioPlayerController._internal(){
    init();
  }

  static AudioPlayer audioPlayer = AudioPlayer();
  String _filePath = "SomeNonExistentPath";

  void init (){
    audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          //MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
    audioPlayer.positionStream.listen((Duration event) {
      SettingsController.slider = event.inMilliseconds;
    });
    audioPlayer.playerStateStream.listen((PlayerState state) {
      // print(state.playing);
      SettingsController.playing = state.playing;
      if (state.processingState == ProcessingState.completed) {
        if (SettingsController.repeat) {
          print("repeat");
          SettingsController.slider = 0;
          play();
        } else {
          print("next");
          skipToNext();
        }
      }
    });
  }


  Future<void> addSong(SongModel song, Uint8List bytes) async {
    File lastFile = File(_filePath);
    if (_filePath != "SomeNonExistentPath" && lastFile.existsSync()) {
      lastFile.deleteSync();
    }
    final String dir = (await getApplicationCacheDirectory()).path;
    final String path = '$dir/${song.album}-${song.title}.png';
    _filePath = path;

    final File file = File(path);
    file.writeAsBytesSync(bytes);

    MediaItem item = MediaItem(
      id: song.id.toString(),
      album: song.album,
      title: song.title,
      artist: song.artist,
      duration: Duration(milliseconds: song.duration ?? 0),
      artUri: file.uri,
    );
    mediaItem.add(item);
  }

  @override
  Future<void> play() async {
    print("play");
    SettingsController.playing = true;
    // await audioPlayer.play(
    //     DeviceFileSource(SettingsController.currentSongPath),
    //     position: Duration(milliseconds: SettingsController.slider),
    //     volume: SettingsController.volume,
    //     balance: SettingsController.balance,
    // );
    audioPlayer.setUrl(SettingsController.currentSongPath, initialPosition: Duration(milliseconds: SettingsController.slider));
    audioPlayer.setVolume(SettingsController.volume);
    audioPlayer.setSpeed(SettingsController.speed);
    await audioPlayer.play();

  }

  @override
  Future<void> pause() async{
    print("pause");
    SettingsController.playing = false;
    await audioPlayer.pause();
  }

  @override
  Future<void> skipToNext() async {
    if (SettingsController.index == SettingsController.queue.length - 1) {
      SettingsController.index = 0;
    } else {
      SettingsController.index = SettingsController.index + 1;
    }
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.skipToPrevious],
    ));
    if (SettingsController.slider > 5000) {
      audioPlayer.seek(const Duration(milliseconds: 0));
    } else {
        if (SettingsController.index == 0) {
          SettingsController.index = SettingsController.queue.length - 1;
        } else {
          SettingsController.index = SettingsController.index - 1;
        }
        play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  void setTimer(String time) {
    final am = AppManager();
    switch (time) {
      case '1 minute':
        print("1 minute");
        SettingsController.sleepTimer = 1 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 1 minute", 3500);
        break;
      case '15 minutes':
        SettingsController.sleepTimer = 15 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 15 minutes", 3500);
        break;
      case '30 minutes':
        SettingsController.sleepTimer = 30 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 30 minutes", 3500);
        break;
      case '45 minutes':
        SettingsController.sleepTimer = 45 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 45 minutes", 3500);
        break;
      case '1 hour':
        SettingsController.sleepTimer = 1 * 60 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 1 hour", 3500);
        break;
      case '2 hours':
        SettingsController.sleepTimer = 2 * 60 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 2 hours", 3500);
        break;
      case '3 hours':
        SettingsController.sleepTimer = 3 * 60 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 3 hours", 3500);
        break;
      case '4 hours':
        SettingsController.sleepTimer = 4 * 60 * 60 * 1000;
        startTimer();
        am.showNotification("Sleep timer set to 4 hours", 3500);
        break;
      default:
        SettingsController.sleepTimer = 0;
        am.showNotification("Sleep timer has been turned off", 3500);
        break;
    }
  }

  void startTimer() {
    final am = AppManager();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (SettingsController.sleepTimer > 0) {
        SettingsController.sleepTimer -= 10;
      } else {
        timer.cancel();
        audioPlayer.pause();
        SettingsController.playing = false;
        am.showNotification("Sleep timer has ended", 3500);
      }
    });
  }


}