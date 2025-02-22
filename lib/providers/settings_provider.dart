import 'package:flutter/cupertino.dart';
import 'package:musicplayerandroid/entities/settings_entity.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';



class SettingsProvider with ChangeNotifier{
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal() {
    initialize();
  }

  SettingsEntity currentSettings = SettingsEntity();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  String get mongoID => currentSettings.mongoID;
  String get email => currentSettings.email;
  String get password => currentSettings.password;
  List<String> get deviceList => currentSettings.deviceList;
  String get primaryDevice => currentSettings.primaryDevice;
  List<String> get missingSongs => currentSettings.missingSongs;
  String get deezerARL => currentSettings.deezerARL;
  bool get firstTime => currentSettings.firstTime;
  bool get appNotifications => currentSettings.appNotifications;
  String get queueAdd => currentSettings.queueAdd;
  String get queuePlay => currentSettings.queuePlay;

  set mongoID(String value) {
    currentSettings.mongoID = value;
    notifyListeners();
  }

  set email(String value) {
    currentSettings.email = value;
    notifyListeners();
  }

  set password(String value) {
    currentSettings.password = value;
    notifyListeners();
  }

  set deviceList(List<String> value) {
    currentSettings.deviceList = value;
    notifyListeners();
  }

  set primaryDevice(String value) {
    currentSettings.primaryDevice = value;
    notifyListeners();
  }

  set missingSongs(List<String> value) {
    currentSettings.missingSongs = value;
    notifyListeners();
  }

  set deezerARL(String value) {
    currentSettings.deezerARL = value;
    notifyListeners();
  }

  set firstTime(bool value) {
    currentSettings.firstTime = value;
    notifyListeners();
  }

  set appNotifications(bool value) {
    currentSettings.appNotifications = value;
    notifyListeners();
  }

  set queueAdd(String value) {
    currentSettings.queueAdd = value;
    notifyListeners();
  }

  set queuePlay(String value) {
    currentSettings.queuePlay = value;
    notifyListeners();
  }


  void initialize() {
    loadSettings();
  }

  void loadSettings() {
    currentSettings = databaseProvider.settings;
  }

  void updateSettings() {
    databaseProvider.updateSettings((settings){
      settings.email = settings.email;
      settings.password = settings.password;
      settings.deviceList = settings.deviceList;
      settings.primaryDevice = settings.primaryDevice;
      settings.firstTime = settings.firstTime;
      settings.appNotifications = settings.appNotifications;
      settings.deezerARL = settings.deezerARL;
      settings.queueAdd = settings.queueAdd;
      settings.queuePlay = settings.queuePlay;
      settings.missingSongs = settings.missingSongs;
    });
  }

}
