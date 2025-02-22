import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/song_player_widget.dart';
import 'package:musicplayerandroid/screens/artists.dart';
import 'package:musicplayerandroid/screens/create.dart';
import 'package:musicplayerandroid/screens/loading_screen.dart';
import 'package:musicplayerandroid/screens/playlists.dart';
import 'package:musicplayerandroid/screens/settings_screen.dart';
import 'package:musicplayerandroid/screens/tracks.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:provider/provider.dart';
import 'albums.dart';
import 'export.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  key: pageProvider.navigatorKey,
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
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.pushReplacement(Tracks.route());
                  },
                ),
                ListTile(
                  title: const Text('Albums'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.pushReplacement(Albums.route());
                  },
                ),
                ListTile(
                  title: const Text('Artists'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.pushReplacement(Artists.route());
                  },
                ),
                ListTile(
                  title: const Text('Playlists'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.pushReplacement(Playlists.route());
                  },
                ),
                ListTile(
                  title: const Text('Create'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.push(CreateScreen.route());
                  },
                ),
                ListTile(
                  title: const Text('Settings'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.pushReplacement(SettingsScreen.route());
                  },
                ),
                ListTile(
                  title: const Text('Export Playlists'),
                  onTap: () {
                    Scaffold.of(pageProvider.navigatorKey.currentContext!).closeEndDrawer();
                    pageProvider.navigatorKey.currentState!.push(ExportScreen.route());
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