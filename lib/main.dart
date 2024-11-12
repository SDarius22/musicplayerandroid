import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'controller/controller.dart';
import 'controller/objectBox.dart';
import 'domain/settings_type.dart';
import 'screens/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> main(List<String> args) async {
  //print(args);
  WidgetsFlutterBinding.ensureInitialized();

  await [
    Permission.mediaLibrary,
    Permission.audio,
    Permission.storage,
  ].request();

  await ObjectBox.initialize();

  var settingsBox = ObjectBox.store.box<Settings>();
  Settings settings = settingsBox.query().build().findFirst() ?? Settings();
  if (args.isNotEmpty) {
    settings.queue.clear();
    settings.queue.addAll(args);
    settings.index = 0;
  }
  settingsBox.put(settings);

  final docsDir = await getApplicationDocumentsDirectory();
  File logFile = File('${docsDir.path}/.musicplayer database/log.txt');
  // File argsFile = File('${docsDir.path}/.musicplayerdatabase/args.txt');
  // if (args.isNotEmpty) {
  //   argsFile.writeAsStringSync(args.join(' '));
  // }
  Controller controller = Controller();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    logFile.writeAsStringSync('${DateTime.now()}: ${details.toString()}\n', mode: FileMode.append);
  };

  runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Bahnschrift',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0E0E0E),
        ),
        debugShowCheckedModeBanner: false,
        //showPerformanceOverlay: true,
        home: MyApp(controller: controller,),
      )
  );
}



