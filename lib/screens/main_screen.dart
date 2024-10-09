import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/screens/song_player_widget.dart';
import '../controller/controller.dart';
import 'settings_screen.dart';
import 'home.dart';

class MyApp extends StatefulWidget {
  final Controller controller;
  const MyApp({super.key, required this.controller});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool volume = true;

  @override
  void initState(){
    super.initState();
    widget.controller.finishedRetrievingNotifier.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.controller.settings.firstTime);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var normalSize = height * 0.0125;

    return Scaffold(
      body: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              MaterialApp(
                theme: ThemeData(
                  fontFamily: 'Bahnschrift',
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: const Color(0xFF0E0E0E),
                ),
                debugShowCheckedModeBanner: false,
                home: HomePage(controller: widget.controller),
              ),
              if(!widget.controller.settings.firstTime)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment.bottomCenter,
                  child: SongPlayerWidget(controller: widget.controller),
                ),
            ],
          ),
      ),
    );
  }
}