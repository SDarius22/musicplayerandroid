import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musicplayerandroid/interface/screens/main_screen.dart';
import 'package:musicplayerandroid/providers/app_audio_handler.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/auth_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:permission_handler/permission_handler.dart';

import 'database/objectBox.dart';
import 'interface/screens/loading_screen.dart';


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
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider()..init(),
        ),
        Provider<LocalDataProvider>(
          create: (_) => LocalDataProvider(),
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (_) => AudioProvider()
            ..initialize(),
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
        home: const MyApp(),
      ),
    );
  }
}



Future<void> initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await [
    Permission.mediaLibrary,
    Permission.audio,
    Permission.storage,
  ].request();
  await ObjectBox.initialize();
  await AppAudioHandler().init();
}

