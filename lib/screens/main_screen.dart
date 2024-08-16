import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/screens/search_widget.dart';
import 'package:musicplayerandroid/screens/song_player_widget.dart';
import 'package:musicplayerandroid/screens/notification_widget.dart';
import '../controller/controller.dart';
import 'settings_screen.dart';
import 'home.dart';
import 'welcome_screen.dart';


class MyApp extends StatefulWidget {
  final Controller controller;
  const MyApp({super.key, required this.controller});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  bool volume = true;
  final ValueNotifier<bool> _visible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    //print(widget.controller.settings.firstTime);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var normalSize = height * 0.02;
    Widget finalWidget = widget.controller.settings.firstTime ?
    WelcomeScreen(controller: widget.controller) :
    HomePage(controller: widget.controller);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.settings_20_regular),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(controller: widget.controller),
                ),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              HeroControllerScope(
                controller: MaterialApp.createMaterialHeroController(),
                child: Navigator(
                  key: widget.controller.navigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => finalWidget,
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: widget.controller.finishedRetrievingNotifier,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      child: !widget.controller.settings.firstTime ? value?
                      SongPlayerWidget(controller: widget.controller) :
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.only(
                          left: width * 0.01,
                          right: width * 0.01,
                          bottom: height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height * 0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: normalSize,
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    );
                  }
              ),
              ValueListenableBuilder(
                  valueListenable: widget.controller.searchNotifier,
                  builder: (context, value, child){
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: value ? GestureDetector(
                        key: const Key("Search Widget"),
                        onTap: (){
                          widget.controller.searchNotifier.value = false;
                        },
                        child: Container(
                          width: width,
                          height: height,
                          color: Colors.black.withOpacity(0.3),
                          child: SearchWidget(controller: widget.controller),
                        ),
                      ) : Container(
                        key: const Key("Search Off"),
                      ),
                    );
                  }
              ),
              ValueListenableBuilder(
                  valueListenable: widget.controller.userMessageNotifier,
                  builder: (context, value, child){
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: value.isNotEmpty ?
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        key: const Key("User Message Widget"),
                        alignment: Alignment.topCenter,
                        child: NotificationWidget(controller: widget.controller),
                      ) : Container(
                        key: const Key("User Message Off"),
                      ),
                    );
                  }
              ),
            ],
          ),
      ),
    );
  }
}