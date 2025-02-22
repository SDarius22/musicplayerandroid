import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/local_data_provider.dart';
import '../../entities//playlist_entity.dart';
import '../../database/objectbox.g.dart';
import '../../utils/fluenticons/fluenticons.dart';

class AddScreen extends StatefulWidget {
  final List<String> paths;
  const AddScreen({super.key, required this.paths});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<int> selected = [];
  late InfoProvider infoProvider;
  late DatabaseProvider databaseProvider;
  late LocalDataProvider localDataProvider;

  @override
  Widget build(BuildContext context) {
    infoProvider = Provider.of<InfoProvider>(context, listen: false);
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
    //print(widget.songs.length);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    var query = databaseProvider.playlistBox.query().order(PlaylistEntity_.name).build();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            FluentIcons.back,
            color: Colors.white,
            size: height * 0.025,
          ),
          onPressed: () {
            // LocalDataProvider.selected = [];
            Navigator.pop(context);
          },
        ),
        actions: [
          ElevatedButton(
              onPressed: selected.isEmpty ? null : (){
                //print("Add to new playlist");
                for(int i = 0; i < selected.length; i++){
                  if(selected[i] == 0){
                    //print(paths);
                    infoProvider.addToQueue(widget.paths);
                  }
                  else{
                    var playlist = query.find()[i];
                    localDataProvider.addToPlaylist(playlist, widget.paths);
                  }
                }
                // LocalDataProvider.selected = [];
                Navigator.pop(context);
              },
              child: Text(
                "Done",
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
            top: height * 0.01,
            left: width * 0.01,
            right: width * 0.01,
            bottom: height * 0.01
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              "Choose one or more playlists to add the selected songs to:",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: normalSize,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: width * 0.01,
                  right: width * 0.01,
                  top: height * 0.01,
                  bottom: width * 0.125,
                ),
                itemCount: query.find().length + 1,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 0.825,
                  maxCrossAxisExtent: width * 0.425,
                  crossAxisSpacing: width * 0.0125,
                  //mainAxisSpacing: width * 0.0125,
                ),
                itemBuilder: (BuildContext context, int index) {
                  PlaylistEntity playlist = PlaylistEntity();
                  if(index > 0){
                    playlist = query.find()[index-1];
                  }
                  return MouseRegion(
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
                                        size: height * 0.05,
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
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}