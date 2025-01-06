import 'dart:async';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:musicplayerandroid/controller/settings_controller.dart';
import 'package:musicplayerandroid/controller/worker_controller.dart';



class AppManager{
  static final AppManager _instance = AppManager._internal();

  factory AppManager() => _instance;

  AppManager._internal();

  final navigatorKey = GlobalKey<NavigatorState>();
  ValueNotifier<bool> minimizedNotifier = ValueNotifier<bool>(true);
  ValueNotifier<String> notificationMessage = ValueNotifier<String>('');
  Widget actions = const SizedBox();

  static void init(){

  }

  void showNotification(String message, int duration, {Widget newActions = const SizedBox()}) {
    if (SettingsController.appNotifications == false) {
      return;
    }
    notificationMessage.value = message;
    actions = newActions;
    Timer.periodic(
      Duration(milliseconds: duration),
          (timer) {
        notificationMessage.value = '';
        actions = const SizedBox();
        timer.cancel();
      },
    );
  }

  static Future<void> updateColors(Uint8List image) async {
    var colors = await WorkerController.getColorIsolate(image);
    SettingsController.lightColorNotifier.value = colors[0];
    SettingsController.darkColorNotifier.value = colors[1];

  }


}