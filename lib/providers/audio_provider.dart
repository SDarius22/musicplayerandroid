import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'settings_provider.dart';


class AudioProvider extends BaseAudioHandler with SeekHandler, ChangeNotifier{
  int indexValue = 0; // index in unshuffled queue
  int slider = 0; // milliseconds
  bool playing = false;
  bool repeatValue = false;
  bool shuffleValue = false;
  double balance = 0;
  double speed = 1;
  double volume = 0.5;
  int sleepTimer = 0; // milliseconds
  List<String> unshuffledQueue = [];
  List<String> shuffledQueue = [];
  SongModel currentSongModel = SongModel({});
  Uint8List currentSongImage = Uint8List(0);
  Color lightColor = Colors.white;
  Color darkColor = Colors.black;
  AudioPlayer audioPlayer = AudioPlayer();

  int get index => indexValue;
  set index(int value) {
    indexValue = value;
    slider = 0;
    updateCurrentSong();
  }

  bool get repeat => repeatValue;
  set repeat(bool value) {
    repeatValue = value;
    notifyListeners();
  }

  bool get shuffle => shuffleValue;
  set shuffle(bool value) {
    shuffleValue = value;
    notifyListeners();
  }

  String get currentSongPath => unshuffledQueue.isNotEmpty? shuffle ? shuffledQueue[index] : unshuffledQueue[index] : '';
  List<String> get currentQueue => shuffle ? shuffledQueue : unshuffledQueue;

  final SettingsProvider settings = SettingsProvider();
  final LocalDataProvider localData = LocalDataProvider();

  static final AudioProvider _instance = AudioProvider._internal();
  factory AudioProvider() => _instance;

  AudioProvider._internal();

  void initialize() {
    initializeListeners();
    updateCurrentSong();
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
      notifyListeners();
    });
  }

  void startStateListener() {
    audioPlayer.playerStateStream.listen((PlayerState state) {
      playing = state.playing;
      if (state.processingState == ProcessingState.completed) {
        if (repeat) {
          replay();
        } else {
          skipToNext();
        }
      }
      notifyListeners();
    });
  }

  Future<Duration> getCurrentSongDuration() async {
    if (currentSongModel.duration != null) {
      return Duration(milliseconds: currentSongModel.duration!);
    }
    return audioPlayer.duration ?? const Duration(milliseconds: 0);
  }

  Future<void> updateCurrentSong() async {
    currentSongModel = await localData.getSong(currentSongPath);
    currentSongImage = await localData.getImage(currentSongModel.id);
    updateNotificationBar(currentSongModel, currentSongImage);
    notifyListeners();
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
        currentSongPath,
        initialPosition: Duration(milliseconds: slider)
    );
    audioPlayer.setVolume(volume);
    audioPlayer.setSpeed(speed);
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
    if (index == unshuffledQueue.length - 1) {
      index = 0;
    } else {
      index += 1;
    }
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    if (slider > 5000) {
      audioPlayer.seek(const Duration(milliseconds: 0));
    } else {
        if (index == 0) {
          index = unshuffledQueue.length - 1;
        } else {
          index -= 1;
        }
        await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> addToQueue(List<String> songs) async {
    if (settings.queueAdd == 'last') {
      unshuffledQueue.addAll(songs);
      shuffledQueue.addAll(songs);
    } else if (settings.queueAdd == 'next') {
      unshuffledQueue.insertAll(index + 1, songs);
      shuffledQueue.insertAll(index + 1, songs);
    } else if (settings.queueAdd == 'first') {
      unshuffledQueue.insertAll(0, songs);
      shuffledQueue.insertAll(0, songs);
    }
    notifyListeners();
  }

  Future<void> removeFromQueue(String song) async {
    if (shuffledQueue.length == 1) {
      debugPrint("The queue cannot be empty");
      return;
    }

    unshuffledQueue.remove(song);
    shuffledQueue.remove(song);
    if (!unshuffledQueue.contains(currentSongPath)) {
      index = 0;
    } else {
      index = unshuffledQueue.indexOf(currentSongPath);
    }
    notifyListeners();
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    String song = unshuffledQueue.removeAt(oldIndex);
    unshuffledQueue.insert(newIndex, song);
    if (oldIndex == index) {
      index = newIndex;
    } else if (oldIndex < index && newIndex >= index) {
      index -= 1;
    } else if (oldIndex > index && newIndex <= index) {
      index += 1;
    }
    notifyListeners();
  }

  Future<void> updatePlaying(List<String> songs, int newIndex) async {
    if (settings.queuePlay == 'all') {
      unshuffledQueue = songs;
      index = newIndex;
    } else {
      addToQueue([songs[newIndex]]);
    }
    notifyListeners();
  }

}