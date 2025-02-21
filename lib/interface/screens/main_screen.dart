import 'package:flutter/material.dart';
import 'package:musicplayerandroid/interface/screens/artists_screen.dart';
import 'package:musicplayerandroid/interface/screens/loading_screen.dart';
import 'package:musicplayerandroid/interface/screens/playlists_screen.dart';
import 'package:musicplayerandroid/interface/screens/tracks_screen.dart';
import 'package:musicplayerandroid/providers/settings_provider.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:provider/provider.dart';
import '../components/song_player_widget.dart';
import 'albums_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Music Player'),
            actions: [
              IconButton(
                icon: const Icon(FluentIcons.menu),
                onPressed: () {
                  Scaffold.of(settings.navigatorKey.currentContext!).openEndDrawer();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  key: settings.navigatorKey,
                  onGenerateRoute: (settings) {
                    return LoadingScreen.route();
                  },
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                alignment: Alignment.bottomCenter,
                child: const SongPlayerWidget(),
              ),
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Tracks'),
                  onTap: () {
                    Scaffold.of(settings.navigatorKey.currentContext!).closeEndDrawer();
                    settings.navigatorKey.currentState!.push(Tracks.route());
                  },
                ),
                ListTile(
                  title: const Text('Albums'),
                  onTap: () {
                    Scaffold.of(settings.navigatorKey.currentContext!).closeEndDrawer();
                    settings.navigatorKey.currentState!.push(Albums.route());
                  },
                ),
                ListTile(
                  title: const Text('Artists'),
                  onTap: () {
                    Scaffold.of(settings.navigatorKey.currentContext!).closeEndDrawer();
                    settings.navigatorKey.currentState!.push(Artists.route());
                  },
                ),
                ListTile(
                  title: const Text('Playlists'),
                  onTap: () {
                    Scaffold.of(settings.navigatorKey.currentContext!).closeEndDrawer();
                    settings.navigatorKey.currentState!.push(Playlists.route());
                  },
                ),
              ],
            ),

          ),
        );
      },
    );
  }
}