import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import '../../providers/local_data_provider.dart';
import '../../entities/playlist_entity.dart';
import '../../database/objectbox.g.dart';
import '../../utils/fluenticons/fluenticons.dart';

class ExportScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const ExportScreen(),
    );
  }

  const ExportScreen({super.key});

  //TODO: Recode this

  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List<int> selected = [];
  @override
  Widget build(BuildContext context) {
    final dc = LocalDataProvider();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.018;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    var query = DatabaseProvider().playlistBox.query().order(PlaylistEntity_.name).build();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            FluentIcons.back,
            size: height * 0.02,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Export Playlists",
          style: TextStyle(
            color: Colors.white,
            fontSize: boldSize,
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: (){
                print("Export");
                for(int i in selected){
                  if(i == 0){
                    PlaylistEntity queuePlaylist = PlaylistEntity();
                    queuePlaylist.name = "Current Queue";
                    queuePlaylist.paths = AudioProvider().currentAudioInfo.unshuffledQueue;
                    dc.exportPlaylist(queuePlaylist);
                  }
                  else{
                    var playlist = query.find()[i-1];
                    dc.exportPlaylist(playlist);
                  }
                }
                Navigator.pop(context);
              },
              child: Text(
                "Export",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: normalSize
                ),
              )
          ),
        ],
      ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.8,
              child: GridView.builder(
                padding: EdgeInsets.all(width * 0.01),
                itemCount: query.find().length + 8,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.8275,
                  maxCrossAxisExtent: width * 0.125,
                  crossAxisSpacing: width * 0.0125,
                  mainAxisSpacing: width * 0.0125,
                ),
                itemBuilder: (BuildContext context, int index) {
                  PlaylistEntity playlist = PlaylistEntity();
                  if(index > 0 && index <= query.find().length){
                    playlist = query.find()[index-1];
                  }
                  return index <= query.find().length ?
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        print("Tapped on $index");
                        setState(() {
                          selected.contains(index) ? selected.remove(index) : selected.add(index);
                        });
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(width * 0.01),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if(index == 0)
                                  AspectRatio(
                                    aspectRatio: 1.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.asset("assets/current_queue.png").image,
                                          )
                                      ),
                                    ),
                                  ),
                                if(selected.contains(index))
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        FluentIcons.check,
                                        size: height * 0.1,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                              ],
                            ),

                          ),
                          SizedBox(
                            height: height * 0.004,
                          ),
                          Text(
                            index == 0 ? "Current Queue" : playlist.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: smallSize,
                                fontWeight: FontWeight.normal
                            ),
                          )


                        ],
                      ),
                    ),
                  ) : SizedBox(
                    width: width * 0.125,
                    height: width * 0.125,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}