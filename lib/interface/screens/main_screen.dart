
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../../controller/app_manager.dart';
import '../../controller/audio_player_controller.dart';
import '../../controller/data_controller.dart';
import '../../controller/online_controller.dart';
import '../../controller/settings_controller.dart';
import '../../controller/worker_controller.dart';
import '../../main.dart';
import '../../repository/objectBox.dart';
import 'home.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  late Future init;

  @override
  void initState(){
    super.initState();
    init = Future(() async {
      await ObjectBox.initialize();
      SettingsController.init();
      WorkerController.init();
      DataController.init();
      audioHandler = await AudioService.init(
        builder: () => AudioPlayerController(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.example.musicplayerandroid.channel.audio',
          androidNotificationChannelName: 'Music Player',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
        ),
      );
      AppManager.init();
      OnlineController.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          return MaterialApp(
            theme: ThemeData(
              fontFamily: 'Bahnschrift',
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0E0E0E),
            ),
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );

  }
}