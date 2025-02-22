import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/entities/audio_info_entity.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'settings_provider.dart';


class AudioProvider extends BaseAudioHandler with SeekHandler, ChangeNotifier{
  static final AudioProvider _instance = AudioProvider._internal();
  factory AudioProvider() => _instance;

  AudioProvider._internal(){
    initialize();
  }

  AudioInfoEntity currentAudioInfo = AudioInfoEntity();
  SongModel currentSongModel = SongModel({});
  Uint8List currentSongImage = Uint8List(0);
  Color lightColor = Colors.white;
  Color darkColor = Colors.black;
  AudioPlayer audioPlayer = AudioPlayer();

  int get index => currentAudioInfo.index;
  set index(int value) {
    currentAudioInfo.index = value;
    currentAudioInfo.slider = 0;
    updateCurrentSong();
  }

  bool get repeat => currentAudioInfo.repeat;
  set repeat(bool value) {
    currentAudioInfo.repeat = value;
    notifyListeners();
  }

  bool get shuffle => currentAudioInfo.shuffle;
  set shuffle(bool value) {
    currentAudioInfo.shuffle = value;
    notifyListeners();
  }

  String get currentSongPath => shuffle
      ? currentAudioInfo.shuffledQueue[index]
      : currentAudioInfo.unshuffledQueue[index];
  List<String> get currentQueue => shuffle
      ? currentAudioInfo.shuffledQueue
      : currentAudioInfo.unshuffledQueue;

  final DatabaseProvider databaseProvider = DatabaseProvider();
  final SettingsProvider settingsProvider = SettingsProvider();
  final LocalDataProvider localDataProvider = LocalDataProvider();

  Future<void> initialize() async {
    loadAudioInfo();
    initializeListeners();
    updateCurrentSong();
  }

  void loadAudioInfo() {
    currentAudioInfo = databaseProvider.audioInfo;
  }

  void updateAudioInfo() {
    databaseProvider.updateAudioInfo((audioInfo) {
      audioInfo.index = currentAudioInfo.index;
      audioInfo.slider = currentAudioInfo.slider;
      audioInfo.playing = currentAudioInfo.playing;
      audioInfo.repeat = currentAudioInfo.repeat;
      audioInfo.shuffle = currentAudioInfo.shuffle;
      audioInfo.balance = currentAudioInfo.balance;
      audioInfo.speed = currentAudioInfo.speed;
      audioInfo.volume = currentAudioInfo.volume;
      audioInfo.sleepTimer = currentAudioInfo.sleepTimer;
      audioInfo.unshuffledQueue = currentAudioInfo.unshuffledQueue;
      audioInfo.shuffledQueue = currentAudioInfo.shuffledQueue;
    });
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
      currentAudioInfo.slider = event.inMilliseconds;
      updateAudioInfo();
      notifyListeners();
    });
  }

  void startStateListener() {
    audioPlayer.playerStateStream.listen((PlayerState state) {
      currentAudioInfo.playing = state.playing;
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
    currentSongModel = await localDataProvider.getSong(currentSongPath);
    currentSongImage = await localDataProvider.getImage(currentSongModel.id);
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
        initialPosition: Duration(milliseconds: currentAudioInfo.slider)
    );
    audioPlayer.setVolume(currentAudioInfo.volume);
    audioPlayer.setSpeed(currentAudioInfo.speed);
    await audioPlayer.play();
  }

  Future<void> replay() async {
    currentAudioInfo.slider = 0;
    play();
  }

  @override
  Future<void> pause() async{
    await audioPlayer.pause();
  }

  @override
  Future<void> skipToNext() async {
    if (index == currentAudioInfo.unshuffledQueue.length - 1) {
      index = 0;
    } else {
      index += 1;
    }
    await play();
  }

  @override
  Future<void> skipToPrevious() async {
    if (currentAudioInfo.slider > 5000) {
      audioPlayer.seek(const Duration(milliseconds: 0));
    } else {
        if (index == 0) {
          index = currentAudioInfo.unshuffledQueue.length - 1;
        } else {
          index -= 1;
        }
        await play();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    notifyListeners();
  }

  Future<void> addToQueue(List<String> songs) async {
    if (settingsProvider.currentSettings.queueAdd == 'last') {
      currentAudioInfo.unshuffledQueue.addAll(songs);
      currentAudioInfo.shuffledQueue.addAll(songs);
    } else if (settingsProvider.currentSettings.queueAdd == 'next') {
      currentAudioInfo.unshuffledQueue.insertAll(index + 1, songs);
      currentAudioInfo.shuffledQueue.insertAll(index + 1, songs);
    } else if (settingsProvider.currentSettings.queueAdd == 'first') {
      currentAudioInfo.unshuffledQueue.insertAll(0, songs);
      currentAudioInfo.shuffledQueue.insertAll(0, songs);
    }
    notifyListeners();
  }

  Future<void> removeFromQueue(String song) async {
    if (currentAudioInfo.shuffledQueue.length == 1) {
      debugPrint("The queue cannot be empty");
      return;
    }

    currentAudioInfo.unshuffledQueue.remove(song);
    currentAudioInfo.shuffledQueue.remove(song);
    if (!currentAudioInfo.unshuffledQueue.contains(currentSongPath)) {
      index = 0;
    } else {
      index = currentAudioInfo.unshuffledQueue.indexOf(currentSongPath);
    }
    notifyListeners();
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    String song = currentAudioInfo.unshuffledQueue.removeAt(oldIndex);
    currentAudioInfo.unshuffledQueue.insert(newIndex, song);
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
    if (settingsProvider.currentSettings.queuePlay == 'all') {
      currentAudioInfo.unshuffledQueue = songs;
      index = newIndex;
    } else {
      addToQueue([songs[newIndex]]);
    }
    notifyListeners();
  }

}