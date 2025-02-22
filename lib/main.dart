import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';
import 'package:musicplayerandroid/screens/home.dart';
import 'package:musicplayerandroid/providers/notification_provider.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/auth_provider.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'database/objectBox.dart';


Future<void> main(List<String> args) async {
  await initializeDependencies();
  runApp(
    const MusicApp(),
  );
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        Provider<DatabaseProvider>(
          create: (_) => DatabaseProvider(),
        ),
        ChangeNotifierProvider<LocalDataProvider>(
          create: (_) => LocalDataProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider<InfoProvider>(
          create: (_) => InfoProvider(),
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (_) => AudioProvider(),
        ),
        Provider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<PageProvider>(
          create: (_) => PageProvider(),
        ),
        ChangeNotifierProvider<SelectionProvider>(
          create: (_) => SelectionProvider(),
        ),
        // ChangeNotifierProvider<AuthProvider>(
        //   create: (_) => AuthProvider(),
        // ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0E0E0E),
        ),
        builder: BotToastInit(),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}



Future<void> initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ObjectBox.initialize();
  await [
    Permission.mediaLibrary,
    Permission.audio,
    Permission.storage,
  ].request();

  await NotificationProvider().init();
}

