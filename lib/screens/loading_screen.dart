import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/screens/tracks.dart';
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
      var infoProvider = Provider.of<InfoProvider>(context, listen: false);
      var pageProvider = Provider.of<PageProvider>(context, listen: false);
      if (infoProvider.currentAudioInfo.unshuffledQueue.isEmpty){
        debugPrint("Queue is empty");
        var songs = await LocalDataProvider().getSongs('');
        infoProvider.currentAudioInfo.unshuffledQueue = songs.map((e) => e.data).toList();
        infoProvider.index = 0;
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
        child: const SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}