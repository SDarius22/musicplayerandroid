import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/entities/audio_info_entity.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'audio_provider.dart';
import 'settings_provider.dart';


class InfoProvider with ChangeNotifier{
  static final InfoProvider _instance = InfoProvider._internal();
  factory InfoProvider() => _instance;

  InfoProvider._internal(){
    initialize();
  }

  AudioInfoEntity currentAudioInfo = AudioInfoEntity();
  SongModel currentSongModel = SongModel({});
  Uint8List currentSongImage = Uint8List(0);
  Color lightColor = Colors.white;
  Color darkColor = Colors.black;

  int get slider => currentAudioInfo.slider;
  set slider(int value) {
    currentAudioInfo.slider = value;
    updateAudioInfo();
  }

  int get index => currentAudioInfo.index;
  set index(int value) {
    currentAudioInfo.index = value;
    currentAudioInfo.slider = 0;
    updateCurrentSong();
    updateAudioInfo();
  }

  bool get repeat => currentAudioInfo.repeat;
  set repeat(bool value) {
    currentAudioInfo.repeat = value;
    updateAudioInfo();
    notifyListeners();
  }

  bool get shuffle => currentAudioInfo.shuffle;
  set shuffle(bool value) {
    currentAudioInfo.shuffle = value;
    updateAudioInfo();
    notifyListeners();
  }

  bool get playing => currentAudioInfo.playing;
  set playing(bool value) {
    currentAudioInfo.playing = value;
    updateAudioInfo();
  }

  double get volume => currentAudioInfo.volume;
  set volume(double value) {
    currentAudioInfo.volume = value;
    updateAudioInfo();
    notifyListeners();
  }

  double get balance => currentAudioInfo.balance;
  set balance(double value) {
    currentAudioInfo.balance = value;
    updateAudioInfo();
    notifyListeners();
  }

  double get speed => currentAudioInfo.speed;
  set speed(double value) {
    currentAudioInfo.speed = value;
    updateAudioInfo();
    notifyListeners();
  }

  List<String> get unshuffledQueue => currentAudioInfo.unshuffledQueue;
  List<String> get shuffledQueue => currentAudioInfo.shuffledQueue;

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

  Future<void> updateCurrentSong() async {
    currentSongModel = await localDataProvider.getSong(currentSongPath);
    currentSongImage = await localDataProvider.getImage(currentSongModel.id);
    // await localDataProvider.getColorIsolate(currentSongImage).then((value) {
    //   lightColor = value[0];
    //   darkColor = value[1];
    // });
    AudioProvider().updateNotificationBar(currentSongModel, currentSongImage);
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