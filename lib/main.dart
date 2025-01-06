import 'dart:async';

import 'package:audio_service/audio_service.dart';

import 'package:flutter/material.dart';

import 'interface/screens/main_screen.dart';

import 'package:permission_handler/permission_handler.dart';

late AudioHandler audioHandler;

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await [
    Permission.mediaLibrary,
    Permission.audio,
    Permission.storage,
  ].request();

  // final docsDir = await getApplicationDocumentsDirectory();
  // File logFile = File(kDebugMode ? '${docsDir.path}/musicplayer-debug ${Platform.operatingSystem}/log.txt' : '${docsDir.path}/musicplayer ${Platform.operatingSystem}/log.txt');
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   FlutterError.dumpErrorToConsole(details, forceReport: true);
  //   try{
  //     logFile.writeAsStringSync('${DateTime.now()}: ${details.toString()}\n', mode: FileMode.append);
  //   } catch (e) {
  //     logFile.createSync(recursive: true);
  //     logFile.writeAsStringSync('${DateTime.now()}: ${details.toString()}\n', mode: FileMode.append);
  //   }
  // };

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bahnschrift',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      ),
      debugShowCheckedModeBanner: false,
      //showPerformanceOverlay: true,
      home: const MyApp(),
    ),
  );
}



