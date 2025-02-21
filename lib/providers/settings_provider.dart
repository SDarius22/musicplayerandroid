import 'package:flutter/cupertino.dart';
import 'package:musicplayerandroid/database/objectBox.dart';
import 'package:musicplayerandroid/entities/settings_entity.dart';



class SettingsProvider with ChangeNotifier{
  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  final navigatorKey = GlobalKey<NavigatorState>();
  bool minimizedValue = true;

  bool get minimized => minimizedValue;
  set minimized(bool minimized) {
    minimizedValue = minimized;
    notifyListeners();
  }

  get settingsBox => ObjectBox.store.box<SettingsEntity>();
  SettingsEntity get settings => settingsBox.getAll().last;

  void init() {
    if (settingsBox.isEmpty()) {
      settingsBox.put(SettingsEntity());
    }
  }

  void _updateSettings(void Function(SettingsEntity) updateFn) {
    final updatedSettings = settings;
    updateFn(updatedSettings);
    settingsBox.put(updatedSettings);
  }

  set settings(SettingsEntity settings) {
    settingsBox.put(settings);
  }

  String get mongoID => settings.mongoID;
  set mongoID(String mongoID) {
    _instance._updateSettings((settings) => settings.mongoID = mongoID);
  }

  String get email => settings.email;
  set email(String email) {
    _instance._updateSettings((settings) => settings.email = email);
  }

  String get password => settings.password;
  set password(String password) {
    _instance._updateSettings((settings) => settings.password = password);
  }

  List<String> get deviceList => settings.deviceList;
  set deviceList(List<String> deviceList) =>
      _instance._updateSettings((settings) => settings.deviceList = deviceList);

  String get primaryDevice => settings.primaryDevice;
  set primaryDevice(String primaryDevice) =>
      _instance._updateSettings((settings) => settings.primaryDevice = primaryDevice);

  List<String> get missingSongs => settings.missingSongs;
  set missingSongs(List<String> missingSongs) =>
      _instance._updateSettings((settings) => settings.missingSongs = missingSongs);


  bool get firstTime => settings.firstTime;
  set firstTime(bool firstTime) {
    _instance._updateSettings((settings) => settings.firstTime = firstTime);
  }


  String get deezerARL => settings.deezerARL;
  set deezerARL(String deezerARL) {
    _instance._updateSettings((settings) => settings.deezerARL = deezerARL);
  }


  String get queueAdd => settings.queueAdd;
  set queueAdd(String queueAdd) {
    _instance._updateSettings((settings) => settings.queueAdd = queueAdd);
  }


  String get queuePlay => settings.queuePlay;
  set queuePlay(String queuePlay) {
    _instance._updateSettings((settings) => settings.queuePlay = queuePlay);
  }
}
