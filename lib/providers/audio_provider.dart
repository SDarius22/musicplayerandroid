import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';


class AudioProvider extends BaseAudioHandler with SeekHandler, ChangeNotifier{
  static final AudioProvider _instance = AudioProvider._internal();
  factory AudioProvider() => _instance;

  AudioProvider._internal(){
    initialize();
  }

  int sliderValue = 0;
  bool playingValue = false;

  AudioPlayer audioPlayer = AudioPlayer();
  final InfoProvider infoProvider = InfoProvider();

  int get slider => sliderValue;
  set slider(int value) {
    sliderValue = value;
    infoProvider.slider = value;
    notifyListeners();
  }

  bool get playing => playingValue;
  set playing(bool value) {
    playingValue = value;
    infoProvider.playing = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    initializeListeners();
    initializeSlider();
  }

  void initializeSlider() {
    slider = infoProvider.slider;
  }

  void initializeListeners () {
    startPlaybackListener();
    startPositionListener();
    startStateListener();
  }

  void startPlaybackListener() {
    audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
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
  }

  void startPositionListener() {
    audioPlayer.positionStream.listen((Duration event)  {
      slider = event.inMilliseconds;
    });
  }

  void startStateListener() {
    audioPlayer.playerStateStream.listen((PlayerState state) {
      infoProvider.playing = state.playing;
      if (state.processingState == ProcessingState.completed) {
        if (infoProvider.repeat) {
          replay();
        } else {
          skipToNext();
        }
      }
      notifyListeners();
    });
  }

  Future<Duration> getCurrentSongDuration() async {
    if (infoProvider.currentSongModel.duration != null) {
      return Duration(milliseconds: infoProvider.currentSongModel.duration!);
    }
    return audioPlayer.duration ?? const Duration(milliseconds: 0);
  }

  Future<void> updateNotificationBar(SongModel song, Uint8List bytes) async {
    // workaround to get the image to show up in the notification
    final String dir = (await getApplicationCacheDirectory()).path;
    final String path = '$dir/${song.album}-${song.title}.jpeg';
    final File file = File(path);
    if (!file.existsSync()) {
      file.writeAsBytesSync(bytes);
    }

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
    audioPlayer.setUrl(
        infoProvider.currentSongPath,
        initialPosition: Duration(milliseconds: infoProvider.slider)
    );
    audioPlayer.setVolume(infoProvider.volume);
    audioPlayer.setSpeed(infoProvider.speed);
    await audioPlayer.play();
  }

  Future<void> replay() async {
    slider = 0;
    play();
  }

  @override
  Future<void> pause() async{
    await audioPlayer.pause();
  }

  @override
  Future<void> skipToNext() async {
    if (infoProvider.index == infoProvider.unshuffledQueue.length - 1) {
      infoProvider.index = 0;
    } else {
      infoProvider.index += 1;
    }
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    if (slider > 5000) {
      audioPlayer.seek(const Duration(milliseconds: 0));
    } else {
        if (infoProvider.index == 0) {
          infoProvider.index = infoProvider.unshuffledQueue.length - 1;
        } else {
          infoProvider.index -= 1;
        }
        await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    notifyListeners();
  }

}