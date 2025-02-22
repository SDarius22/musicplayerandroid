import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/screens/tracks_screen.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/audio_provider.dart';
import '../../providers/local_data_provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const LoadingScreen(),
    );
  }

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with AfterLayoutMixin<LoadingScreen> {
  @override
  void afterFirstLayout(BuildContext context) {
    _routeUser();
  }

  void _routeUser() async {
    if (mounted) {
      var localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
      var audioProvider = Provider.of<AudioProvider>(context, listen: false);
      var pageProvider = Provider.of<PageProvider>(context, listen: false);
      if (audioProvider.currentAudioInfo.unshuffledQueue.isEmpty){
        print("Queue is empty");
        var songs = await localDataProvider.getSongs('');
        audioProvider.currentAudioInfo.unshuffledQueue = songs.map((e) => e.data).toList();
        int newIndex = 0;
        audioProvider.index = newIndex;
      }
      pageProvider.navigatorKey.currentState!.pushReplacement(Tracks.route());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}