import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/controller/settings_controller.dart';
import 'package:musicplayerandroid/controller/worker_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../controller/data_controller.dart';
import '../../main.dart';
import 'add_screen.dart';
import '../widgets/image_widget.dart';

class AlbumScreen extends StatefulWidget {
  final AlbumModel album;
  const AlbumScreen({super.key, required this.album});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  String duration = "0 seconds";
  List<SongModel> songs = [];

  @override
  Widget build(BuildContext context) {
    final dc = DataController();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: (){
              print("Add ${widget.album.album}");
              Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => AddScreen(songs: songs)
                )
              );
            },
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(
            top: height * 0.01,
            left: width * 0.01,
            right: width * 0.01,
            bottom: height * 0.01
        ),
        alignment: Alignment.center,
        child: FutureBuilder(
          future: WorkerController.audioQuery.queryAudiosFrom(
            AudiosFromType.ALBUM_ID,
            widget.album.id,
          ),
          builder: (context, snapshot){
            if(snapshot.hasData){
              songs = snapshot.data as List<SongModel>;
              print("Songs: ${songs.length}");
              int totalDuration = 0;
              for(int i = 0; i < songs.length; i++){
                totalDuration += songs[i].duration ?? 0;
              }
              String dur = " ${totalDuration ~/ 3600000} hours, ${(totalDuration % 3600000 ~/ 60000)} minutes and ${(totalDuration ~/1000 % 60)} seconds";
              dur = dur.replaceAll(" 0 hours,", "");
              dur = dur.replaceAll(" 0 minutes and", "");
              duration = dur;
            }
            if(snapshot.hasError){
              print(snapshot.error);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: width * 0.9,
                  padding: EdgeInsets.only(
                    top: height * 0.01,
                    bottom: height * 0.01,
                  ),
                  margin: EdgeInsets.only(
                    left: width * 0.15,
                    right: width * 0.15,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Hero(
                          tag: widget.album.album,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(width * 0.025),
                              child: FutureBuilder(
                                future: WorkerController.audioQuery.queryArtwork(widget.album.id, ArtworkType.ALBUM, size: 512),
                                builder: (context, snapshot){
                                  return AspectRatio(
                                    aspectRatio: 1.0,
                                    child: snapshot.hasData?
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.memory(snapshot.data!).image,
                                          )
                                      ),
                                    ):
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.asset("assets/bg.png").image,
                                          )
                                      ),
                                    ),
                                  );
                                },
                              )
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          widget.album.album,
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
                          widget.album.artist ?? "Unknown Album Artist",
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
                        snapshot.hasData ?
                        Text(
                          "$duration  |  ${widget.album.numOfSongs} song${widget.album.numOfSongs > 1 ? "s" : ""}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: smallSize,
                            fontWeight: FontWeight.normal,
                          ),
                        ) :
                        Text(
                          "${widget.album.numOfSongs} song${widget.album.numOfSongs > 1 ? "s" : ""}",
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
                      ]
                  ),
                ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: width * 0.9,
                  height: height * 0.4,
                  margin: EdgeInsets.only(
                    left: width * 0.05,
                    right: width * 0.05,
                  ),
                  child: snapshot.hasData ?
                  Scrollbar(
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, int index) {
                        var song = songs[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          height: height * 0.1,
                          padding: EdgeInsets.only(
                            right: width * 0.01,
                          ),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                var songPaths = songs.map((e) => e.data).toList();
                                if(SettingsController.queue.equals(songPaths) == false){
                                  dc.updatePlaying(songPaths, index);
                                }
                                SettingsController.index = SettingsController.currentQueue.indexOf(songs[index].data);
                                await audioHandler.play();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(width * 0.01),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: width * 0.0075,
                                    right: width * 0.025,
                                    top: height * 0.0075,
                                    bottom: height * 0.0075,
                                  ),
                                  color: const Color(0xFF0E0E0E),
                                  height: height * 0.125,
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(height * 0.02),
                                            child: ImageWidget(
                                              id: song.id,
                                            ),
                                          ),
                                          BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                                              child: Text(
                                                  "${song.track}",
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
                                                song.title.toString().length > 40 ? "${song.title.toString().substring(0, 40)}..." : song.title.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: normalSize,
                                                )
                                            ),
                                            SizedBox(
                                              height: height * 0.005,
                                            ),
                                            Text(
                                                song.artist == null ? "Unknown artist" : song.artist.toString().length > 60 ? "${song.artist.toString().substring(0, 60)}..." : song.artist.toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: smallSize,
                                                )
                                            ),
                                          ]
                                      ),
                                      const Spacer(),
                                      Text(
                                          song.duration == null || song.duration == 0 ? "??:??" : "${song.duration! ~/ 60000}:${(song.duration! ~/1000 % 60).toString().padLeft(2, '0')}",
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
                  ) :
                  snapshot.hasError ?
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: height * 0.1,
                          color: Colors.red,
                        ),
                        Text(
                          "Error loading songs",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallSize,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {});
                          },
                          child: Text(
                            "Retry",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: smallSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}