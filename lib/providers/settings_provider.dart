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

  bool minimizedValue = true;
  final navigatorKey = GlobalKey<NavigatorState>();
  final DatabaseProvider databaseProvider = DatabaseProvider();

  bool get minimized => minimizedValue;
  set minimized(bool minimized) {
    minimizedValue = minimized;
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
