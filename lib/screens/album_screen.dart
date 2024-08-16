import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/utils/hover_widget/hover_container.dart';
import 'package:musicplayerandroid/domain/album_type.dart';
import '../controller/controller.dart';
import 'add_screen.dart';
import 'image_widget.dart';

class AlbumScreen extends StatefulWidget {
  final Controller controller;
  final AlbumType album;
  const AlbumScreen({super.key, required this.controller, required this.album});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  String duration = "0 seconds";


  @override
  void initState() {
    widget.album.songs.sort((a, b) => a.trackNumber.compareTo(b.trackNumber));
    int totalDuration = 0;
    for (int i = 0; i < widget.album.songs.length; i++){
      totalDuration += widget.album.songs[i].duration;
    }
    duration = " ${totalDuration ~/ 3600} hours, ${(totalDuration % 3600 ~/ 60)} minutes and ${(totalDuration % 60)} seconds";
    duration = duration.replaceAll(" 0 hours,", "");
    duration = duration.replaceAll(" 0 minutes and", "");

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.025;
    var normalSize = height * 0.02;
    var smallSize = height * 0.015;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(
            top: height * 0.02,
            left: width * 0.01,
            right: width * 0.01,
            bottom: height * 0.02
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: (){
                print("Back");
                Navigator.pop(context);
              },
              icon: Icon(
                FluentIcons.arrow_left_16_filled,
                size: height * 0.02,
                color: Colors.white,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: width * 0.4,
              padding: EdgeInsets.only(
                top: height * 0.1,
                bottom: height * 0.05,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Hero(
                      tag: widget.album.name,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        height: height * 0.5,
                        padding: EdgeInsets.only(
                          bottom: height * 0.01,
                        ),
                        //color: Colors.red,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.025),
                          child: ImageWidget(
                            controller: widget.controller,
                            path: widget.album.songs.first.path,
                          ),
                        ),

                      ),
                    ),
                    Text(
                      widget.album.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: boldSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    Text(
                      widget.album.songs.first.albumArtist,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: normalSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    Text(
                      "$duration    |  ${widget.album.songs.length} song${widget.album.songs.length > 1 ? "s" : ""}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: smallSize,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              //print("Playing ${widget.controller.indexNotifier.value}");
                              //widget.controller.audioPlayer.stop();
                              var songPaths = widget.album.songs.map((e) => e.path).toList();
                              if(widget.controller.settings.playingSongsUnShuffled.equals(songPaths) == false){
                                widget.controller.updatePlaying(songPaths, 0);
                              }
                              widget.controller.indexChange(songPaths.first);
                              await widget.controller.playSong();
                            },
                            icon: Icon(
                              FluentIcons.play_12_filled,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              print("Add ${widget.album.name}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddScreen(controller: widget.controller, songs: widget.album.songs)
                                  )
                              );
                            },
                            icon: Icon(
                              FluentIcons.add_12_filled,
                              color: Colors.white,
                              size: height * 0.025,
                            ),
                          ),
                        ]
                    ),
                  ]
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: width * 0.45,
              padding: EdgeInsets.only(
                top: height * 0.1,
                bottom: height * 0.2,
                left: width * 0.02,
              ),
              child: ListView.builder(
                itemCount: widget.album.songs.length,
                itemBuilder: (context, int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: height * 0.125,
                    padding: EdgeInsets.only(
                      right: width * 0.01,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          var songPaths = widget.album.songs.map((e) => e.path).toList();
                          if(widget.controller.settings.playingSongs.equals(songPaths) == false){
                            widget.controller.updatePlaying(songPaths, index);
                          }
                          widget.controller.indexChange(widget.controller.settings.playingSongsUnShuffled[index]);
                          await widget.controller.playSong();
                          // widget.album.name.substring(0, widget.album.name.length > 60 ? 60 : widget.album.name.length);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.01),
                          child: HoverContainer(
                            padding: EdgeInsets.only(
                              left: width * 0.0075,
                              right: width * 0.025,
                              top: height * 0.0075,
                              bottom: height * 0.0075,
                            ),
                            hoverColor: const Color(0xFF242424),
                            normalColor: const Color(0xFF0E0E0E),
                            height: height * 0.125,
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(height * 0.02),
                                      child: ImageWidget(
                                        controller: widget.controller,
                                        path: widget.album.songs[index].path,
                                      ),
                                    ),
                                    BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                        child: Text(
                                            "${widget.album.songs[index].trackNumber}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: boldSize,
                                            )
                                        )
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.01,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.album.songs[index].title.toString().length > 40 ? "${widget.album.songs[index].title.toString().substring(0, 40)}..." : widget.album.songs[index].title.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: normalSize,
                                          )
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Text(
                                          widget.album.songs[index].artists.toString().length > 60 ? "${widget.album.songs[index].artists.toString().substring(0, 60)}..." : widget.album.songs[index].artists.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: smallSize,
                                          )
                                      ),
                                    ]
                                ),
                                const Spacer(),
                                Text(
                                    "${widget.album.songs[index].duration ~/ 60}:${(widget.album.songs[index].duration % 60).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: normalSize,
                                    )
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}