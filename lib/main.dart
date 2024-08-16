import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'controller/controller.dart';
import 'controller/objectBox.dart';
import 'screens/main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

late ObjectBox objectBox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<Permission, PermissionStatus> statuses = await [
    Permission.mediaLibrary,
    Permission.audio,
    Permission.storage,
  ].request();
  objectBox = await ObjectBox.create();
  Controller controller = Controller(objectBox);



  runApp(
      MaterialApp(
        theme: ThemeData(
          fontFamily: 'Bahnschrift',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0E0E0E),
        ),
        debugShowCheckedModeBanner: false,
        //showPerformanceOverlay: true,
        home: MyApp(controller: controller),
      )
  );
}



