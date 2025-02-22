import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/navigation_observer.dart';
import 'package:musicplayerandroid/components/song_player_widget.dart';
import 'package:musicplayerandroid/screens/artists_screen.dart';
import 'package:musicplayerandroid/screens/loading_screen.dart';
import 'package:musicplayerandroid/screens/playlists_screen.dart';
import 'package:musicplayerandroid/screens/tracks_screen.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:provider/provider.dart';
import 'albums_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PageProvider>(
      builder: (context, pageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: pageProvider.isSecondaryPage ? null : const Text('Music Player'),
            leading: pageProvider.isSecondaryPage
                ? IconButton(
                    icon: const Icon(FluentIcons.left),
                    onPressed: () {
                      pageProvider.navigatorKey.currentState!.pop();
                    },
                  )
                : null,
            actions: pageProvider.isSecondaryPage
            ? null
            : [
              IconButton(
                icon: const Icon(FluentIcons.menu),
                onPressed: () {
                  Scaffold.of(pageProvider.navigatorKey.currentContext!).openEndDrawer();
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  key: pageProvider.navigatorKey,
                  observers: [SecondNavigatorObserver()],
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
          endDrawer: pageProvider.isSecondaryPage
            ? null
            : Drawer(
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
              ],
            ),

          ),
        );
      },
    );
  }
}