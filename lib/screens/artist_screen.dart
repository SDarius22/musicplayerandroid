import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/utils/extensions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../providers/audio_provider.dart';
import '../../providers/local_data_provider.dart';
import '../components/image_widget.dart';
import 'add_screen.dart';

class ArtistScreen extends StatelessWidget {
  final ArtistModel artist;
  const ArtistScreen({super.key, required this.artist});

  Future<List<SongModel>> getArtistSongs() async {
    LocalDataProvider localDataProvider = LocalDataProvider();
    List<SongModel> songs = await localDataProvider.audioQuery.queryAudiosFrom(
      AudiosFromType.ARTIST_ID,
      artist.id,
    );
    return songs;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return FutureBuilder(
      future: getArtistSongs(),
      builder: (context, snapshot) {
        return Scaffold(
          // appBar: AppBar(
          //   actions: [
          //     IconButton(
          //       icon: const Icon(
          //         Icons.add,
          //         color: Colors.white,
          //       ),
          //       onPressed: (){
          //         print("Add ${artist.artist}");
          //         List<String> songsPaths = songs.map((e) => e.data).toList();
          //         Navigator.push(context,
          //             MaterialPageRoute(
          //                 builder: (context) => AddScreen(
          //                   paths: songsPaths,
          //                 )
          //             )
          //         );
          //       },
          //     ),
          //   ],
          // ),
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
            child: snapshot.hasData
              ? Column(
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
                            tag: artist.artist,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(width * 0.025),
                                child: FutureBuilder(
                                  future: LocalDataProvider().audioQuery.queryArtwork(artist.id, ArtworkType.ARTIST, size: 512),
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
                                              image: Image.asset("assets/logo.png").image,
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
                            artist.artist,
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
                          snapshot.hasData ?
                          Text(
                            "${artist.numberOfTracks} song${(artist.numberOfTracks ?? 0) > 1 ? "s" : ""}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: smallSize,
                              fontWeight: FontWeight.normal,
                            ),
                          ) :
                          Text(
                            "${artist.numberOfTracks} song${(artist.numberOfTracks ?? 0) > 1 ? "s" : ""}",
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
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          var song = snapshot.data![index];
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
                                  var songPaths = snapshot.data!.map((e) => e.data).toList();
                                  final AudioProvider audioProvider = AudioProvider();
                                  if(audioProvider.currentAudioInfo.unshuffledQueue.equals(songPaths) == false){
                                    audioProvider.updatePlaying(songPaths, index);
                                  }
                                  audioProvider.index = audioProvider.currentQueue.indexOf(snapshot.data![index].data);
                                  await audioProvider.play();
                                  // widget.album.name.substring(0, widget.album.name.length > 60 ? 60 : widget.album.name.length);
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
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(height * 0.02),
                                          child: ImageWidget(
                                            id: song.id,
                                            heroTag: song.id.toString(),
                                          ),
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
                    ),
                  ),
                ],
              )
              : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    );
  }
}