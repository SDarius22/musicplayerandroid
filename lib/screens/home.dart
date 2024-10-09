import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/screens/settings_screen.dart';
import '../controller/controller.dart';
import 'albums.dart';
import 'artists.dart';
import 'download.dart';
import 'tracks.dart';
import 'playlists.dart';


class HomePage extends StatefulWidget {
  final Controller controller;
  const HomePage({super.key, required this.controller});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool volume = true;

  int currentPage = 4;
  String userMessage = "No message";
  final PageController _pageController = PageController(initialPage: 5);



  @override
  void initState(){
    super.initState();
    widget.controller.initDeezer();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.015;
    var normalSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Music Player",
          style: TextStyle(
            color: Colors.white,
            fontSize: boldSize,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(controller: widget.controller)),
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                        height: height * 0.05,
                        color: currentPage != 0 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              //print("Artists");
                              _pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                            },
                            child: Text(
                              "Artists",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: currentPage != 0 ? normalSize : boldSize,
                              ),
                            )
                        )
                    )
                ),
                Expanded(
                    child: Container(
                        height: height * 0.05,
                        color: currentPage != 1 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              //print("Artists");
                              _pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                            },
                            child: Text(
                              "Albums",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: currentPage != 1 ? normalSize : boldSize,
                              ),
                            )
                        )
                    )
                ),
                Expanded(
                    child: Container(
                        height: height * 0.05,
                        color: currentPage != 2 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              //print("Artists");
                              _pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                            },
                            child: Text(
                              "Download",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: currentPage != 2 ? normalSize : boldSize,
                              ),
                            )
                        )
                    )
                ),
                Expanded(
                    child: Container(
                        height: height * 0.05,
                        color: currentPage != 3 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              //print("Artists");
                              _pageController.animateToPage(3,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                            },
                            child: Text(
                              "Playlists",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: currentPage != 3 ? normalSize : boldSize,
                              ),
                            )
                        )
                    )
                ),
                Expanded(
                    child: Container(
                        height: height * 0.05,
                        color: currentPage != 4 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
                        alignment: Alignment.center,
                        child: GestureDetector(
                            onTap: (){
                              //print("Artists");
                              _pageController.animateToPage(4,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn
                              );
                            },
                            child: Text(
                              "Tracks",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: currentPage != 4 ? normalSize : boldSize,
                              ),
                            )
                        )
                    )
                ),
              ],
            ),
            Expanded(
              child: PageView(
                onPageChanged: (int index){
                  setState(() {
                    currentPage = index;
                  });
                },
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                scrollBehavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Artists(controller: widget.controller),
                  Albums(controller: widget.controller),
                  Download(controller: widget.controller),
                  Playlists(controller: widget.controller),
                  Tracks(controller: widget.controller),
                ],

              ),
            ),

          ],
        ),
      ),
    );
  }
}


