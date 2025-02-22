import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/utils/extensions.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../providers/audio_provider.dart';
import '../../providers/local_data_provider.dart';
import '../components/image_widget.dart';
import 'add.dart';

class AlbumScreen extends StatelessWidget {
  final AlbumModel album;
  const AlbumScreen({super.key, required this.album});

  Future<List<SongModel>> getAlbumSongs() async {
    LocalDataProvider localDataProvider = LocalDataProvider();
    List<SongModel> songs = await localDataProvider.audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      album.id,
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
      future: getAlbumSongs(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                FluentIcons.back,
                color: Colors.white,
                size: height * 0.025,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: snapshot.hasData == false ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddScreen(paths: snapshot.data!.map((e) => e.data).toList()),
                    ),
                  );
                },
                icon: Icon(
                  FluentIcons.add,
                  color: Colors.white,
                  size: height * 0.025,
                ),
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
                              tag: album.album,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width * 0.025),
                                  child: FutureBuilder(
                                    future: LocalDataProvider().audioQuery.queryArtwork(album.id, ArtworkType.ALBUM, size: 512),
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
                              album.album,
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
                              album.artist ?? "Unknown Album Artist",
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
                              "${album.numOfSongs} song${album.numOfSongs > 1 ? "s" : ""}",
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
                                                  heroTag: song.id.toString(),
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
                      )
                    ),
                    SizedBox(
                      width: width * 0.02,
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
      },
    );
  }
}