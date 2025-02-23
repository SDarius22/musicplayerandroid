import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/image_widget.dart';
import 'package:musicplayerandroid/entities/playlist_entity.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/database_provider.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/utils/extensions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../providers/notification_provider.dart';
import '../../providers/local_data_provider.dart';
import '../../providers/settings_provider.dart';
import 'add.dart';

class PlaylistScreen extends StatefulWidget {
  final PlaylistEntity playlist;
  const PlaylistScreen({super.key, required this.playlist});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  ValueNotifier<bool> editMode = ValueNotifier<bool>(false);
  String featuredArtists = "";
  String duration = "0 seconds";

  late Future init;

  @override
  void initState() {
    init = Future(() async {
      int totalDuration = widget.playlist.duration;
      duration = " ${totalDuration ~/ 3600} hours, ${(totalDuration % 3600 ~/ 60)} minutes and ${(totalDuration % 60)} seconds";
      duration = duration.replaceAll(" 0 hours,", "");
      duration = duration.replaceAll(" 0 minutes and", "");
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: (){
              print("Add ${widget.playlist.name}");
              List<String> songsPaths = widget.playlist.paths;
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => AddScreen(
                        paths: songsPaths,
                      )
                  )
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: (){
              print("Edit ${widget.playlist.name}");
              if(editMode.value == false){
                editMode.value = true;
              }
              else{
                editMode.value = false;
                DatabaseProvider().playlistBox.put(widget.playlist);
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              print("Delete ${widget.playlist.name}");
              LocalDataProvider().deletePlaylist(widget.playlist);
              Navigator.pop(context);
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
          future: init,
          builder: (context, notImportant) {
            if (notImportant.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
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
                          tag: widget.playlist.name,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(width * 0.025),
                              child: ImageWidget(
                                path: widget.playlist.paths.first,
                                heroTag: widget.playlist.name,
                              ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          widget.playlist.name,
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
                          featuredArtists,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: smallSize,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        Text(
                          duration,
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
                      itemCount: widget.playlist.paths.length,
                      itemExtent: height * 0.1,
                      itemBuilder: (context, int index) {
                        return FutureBuilder(
                          future: LocalDataProvider().getSong(widget.playlist.paths[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var song = snapshot.data as SongModel;
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
                                      var songPaths = widget.playlist.paths;
                                      var infoProvider = InfoProvider();
                                      if(infoProvider.unshuffledQueue.equals(songPaths) == false){
                                        infoProvider.updatePlaying(songPaths, index);
                                      }
                                      infoProvider.index = infoProvider.currentQueue.indexOf(song.data);
                                      await AudioProvider().play();
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
                                                heroTag: song.data,
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
                            }
                            else{
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
                                      // var songPaths = widget.playlist.paths;
                                      // if(SettingsController.queue.equals(songPaths) == false){
                                      //   dc.updatePlaying(songPaths, index);
                                      // }
                                      // SettingsController.index = SettingsController.currentQueue.indexOf(song.data);
                                      // await AppAudioHandler.play();
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
                                                id: -1,
                                                heroTag: "Loading",
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
                                                      'Loading song details...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: normalSize,
                                                      )
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.005,
                                                  ),
                                                  Text(
                                                      'Loading song artist...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: smallSize,
                                                      )
                                                  ),
                                                ]
                                            ),
                                            const Spacer(),
                                            Text(
                                                "??:??",                                                style: TextStyle(
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
                            }
                          },
                        );
                      },
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
        // child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       onPressed: (){
        //         print("Back");
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(
        //         FluentIcons.back,
        //         size: height * 0.02,
        //         color: Colors.white,
        //       ),
        //     ),
        //     AnimatedContainer(
        //       duration: const Duration(milliseconds: 500),
        //       width: width * 0.4,
        //       padding: EdgeInsets.only(
        //         top: height * 0.1,
        //         bottom: height * 0.05,
        //       ),
        //       child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children:[
        //             ValueListenableBuilder(
        //                 valueListenable: editMode,
        //                 builder: (context, value, child){
        //                   return Hero(
        //                     tag: widget.playlist.name,
        //                     child: AnimatedContainer(
        //                       duration: const Duration(milliseconds: 500),
        //                       curve: Curves.easeInOut,
        //                       height: height * 0.5,
        //                       padding: EdgeInsets.only(
        //                         bottom: height * 0.01,
        //                       ),
        //                       //color: Colors.red,
        //                       child: ClipRRect(
        //                         borderRadius: BorderRadius.circular(width * 0.025),
        //                         child: ImageWidget(
        //                           id: songs.value.first.id,
        //                         ),
        //                       ),
        //
        //                     ),
        //                   );
        //
        //                 }
        //             ),
        //
        //             ValueListenableBuilder(
        //               valueListenable: editMode,
        //               builder: (context, value, child){
        //                 return AnimatedSwitcher(
        //                   duration: const Duration(milliseconds: 500),
        //                   child: value == false ?
        //                   Text(
        //                     widget.playlist.name,
        //                     key: const ValueKey("Playlist Name"),
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                     textAlign: TextAlign.center,
        //                     style: TextStyle(
        //                       fontSize: boldSize,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                   ) :
        //                   SizedBox(
        //                       key: const ValueKey("Playlist Name Edit"),
        //                       width: width * 0.2,
        //                       child: TextFormField(
        //                         initialValue: widget.playlist.name,
        //                         decoration: InputDecoration(
        //                           isDense: true,
        //                           contentPadding: EdgeInsets.only(
        //                             top: height * 0.008,
        //                             bottom: height * 0.008,
        //                             left: width * 0.01,
        //                             right: width * 0.01,
        //                           ),
        //                           hintText: "Playlist Name",
        //                           hintStyle: TextStyle(
        //                             color: Colors.grey.shade600,
        //                             fontSize: normalSize,
        //                           ),
        //                           border: OutlineInputBorder(
        //                             borderRadius: BorderRadius.circular(width * 0.005),
        //                           ),
        //                         ),
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(
        //                           color: Colors.white,
        //                           fontSize: normalSize,
        //                         ),
        //                         onChanged: (value){
        //                           widget.playlist.name = value;
        //                         },
        //                       )
        //                   ),
        //
        //                 );
        //               },
        //             ),
        //
        //             SizedBox(
        //               height: height * 0.005,
        //             ),
        //             Text(
        //               featuredArtists,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: normalSize,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               height: height * 0.005,
        //             ),
        //             Text(
        //               duration,
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 fontSize: smallSize,
        //                 fontWeight: FontWeight.normal,
        //               ),
        //             ),
        //             SizedBox(
        //               height: height * 0.005,
        //             ),
        //             Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: [
        //                   IconButton(
        //                     onPressed: () async {
        //                       if(SettingsController.queue.equals(widget.playlist.paths) == false){
        //                         dc.updatePlaying(widget.playlist.paths, 0);
        //                       }
        //                       SettingsController.index = SettingsController.currentQueue.indexOf(widget.playlist.paths.first);
        //                       await AppAudioHandler.play();
        //                     },
        //                     icon: Icon(
        //                       FluentIcons.play,
        //                       color: Colors.white,
        //                       size: height * 0.025,
        //                     ),
        //                   ),
        //
        //                   IconButton(
        //                     onPressed: (){
        //                       print("Add ${widget.playlist.name}");
        //                       List<String> paths = songs.value.map((e) => e.data).toList();
        //                       Navigator.push(
        //                           context,
        //                           MaterialPageRoute(
        //                               builder: (context) => AddScreen(paths: paths)
        //                           )
        //                       );
        //                     },
        //                     icon: Icon(
        //                       FluentIcons.add,
        //                       color: Colors.white,
        //                       size: height * 0.025,
        //                     ),
        //                   ),
        //                   IconButton(
        //                     onPressed: () {
        //                       print("Delete ${widget.playlist.name}");
        //                       dc.deletePlaylist(widget.playlist);
        //                       Navigator.pop(context);
        //                     },
        //                     icon: Icon(
        //                       FluentIcons.trash,
        //                       color: Colors.white,
        //                       size: height * 0.025,
        //                     ),
        //                   ),
        //
        //                 ]
        //             ),
        //
        //           ]
        //       ),
        //     ),
        //     AnimatedContainer(
        //       duration: const Duration(milliseconds: 500),
        //       width: width * 0.45,
        //       padding: EdgeInsets.only(
        //         left: width * 0.02,
        //         top: height * 0.1,
        //         bottom: height * 0.2,
        //       ),
        //       child: ValueListenableBuilder(
        //         valueListenable: editMode,
        //         builder: (context, value, child){
        //           return AnimatedSwitcher(
        //             duration: const Duration(milliseconds: 500),
        //             reverseDuration: const Duration(milliseconds: 500),
        //             child: value == false ?
        //             ListView.builder(
        //               key: const ValueKey("Normal List"),
        //               itemCount:  songs.value.length,
        //               itemBuilder: (context, int index) {
        //                 //print("Building ${widget.playlist. songs.value[widget.playlist.order[index]].title}");
        //                 SongModel song =  songs.value[index];
        //                 return AnimatedContainer(
        //                   duration: const Duration(milliseconds: 500),
        //                   curve: Curves.easeInOut,
        //                   height: height * 0.125,
        //                   padding: EdgeInsets.only(
        //                     right: width * 0.01,
        //                   ),
        //                   child: MouseRegion(
        //                     cursor: SystemMouseCursors.click,
        //                     child: GestureDetector(
        //                       behavior: HitTestBehavior.translucent,
        //                       onTap: () async {
        //                         if(SettingsController.queue.equals(widget.playlist.paths) == false){
        //                           dc.updatePlaying(widget.playlist.paths, index);
        //                         }
        //                         SettingsController.index = SettingsController.currentQueue.indexOf(widget.playlist.paths[index]);
        //                         await AppAudioHandler.play();
        //                       },
        //                       child: ClipRRect(
        //                         borderRadius: BorderRadius.circular(width * 0.01),
        //                         child: HoverContainer(
        //                           hoverColor: const Color(0xFF242424),
        //                           normalColor: const Color(0xFF0E0E0E),
        //                           padding: EdgeInsets.only(
        //                             left: width * 0.0075,
        //                             right: width * 0.025,
        //                             top: height * 0.0075,
        //                             bottom: height * 0.0075,
        //                           ),
        //                           height: height * 0.125,
        //                           child: Row(
        //                             children: [
        //                               ClipRRect(
        //                                 borderRadius: BorderRadius.circular(width * 0.01),
        //                                 child: ImageWidget(
        //                                   id: song.id,
        //                                 ),
        //                               ),
        //                               SizedBox(
        //                                 width: width * 0.01,
        //                               ),
        //                               Column(
        //                                   mainAxisAlignment: MainAxisAlignment.center,
        //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                         song.title.toString().length > 60 ? "${song.title.toString().substring(0, 60)}..." : song.title.toString(),
        //                                         style: TextStyle(
        //                                           color: Colors.white,
        //                                           fontSize: normalSize,
        //                                         )
        //                                     ),
        //                                     SizedBox(
        //                                       height: height * 0.005,
        //                                     ),
        //                                     Text(
        //                                         song.artist.toString().length > 60 ? "${song.artist.toString().substring(0, 60)}..." : song.artist.toString(),
        //                                         style: TextStyle(
        //                                           color: Colors.white,
        //                                           fontSize: smallSize,
        //                                         )
        //                                     ),
        //                                   ]
        //                               ),
        //                               const Spacer(),
        //                               Text(
        //                                   song.duration == null || song.duration == 0 ? "??:??" : "${song.duration! ~/ 60}:${(song.duration! % 60).toString().padLeft(2, '0')}",
        //                                   style: TextStyle(
        //                                     color: Colors.white,
        //                                     fontSize: normalSize,
        //                                   )
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               },
        //             ) :
        //             ValueListenableBuilder(
        //                 valueListenable: songs,
        //                 builder: (context, value2, child){
        //                   return ReorderableListView.builder(
        //                     key: const ValueKey("Edit List"),
        //                     padding: EdgeInsets.only(
        //                       right: width * 0.01,
        //                     ),
        //                     itemBuilder: (context, int index) {
        //                       //print("Building ${widget.playlist. songs.value[widget.playlist.order[index]].title}");
        //                       SongModel song =  songs.value[index];
        //                       return AnimatedContainer(
        //                         key: Key('$index'),
        //                         duration: const Duration(milliseconds: 500),
        //                         curve: Curves.easeInOut,
        //                         height: height * 0.125,
        //                         child: Container(
        //                           padding: EdgeInsets.only(
        //                             left: width * 0.0075,
        //                             right: width * 0.025,
        //                             top: height * 0.0075,
        //                             bottom: height * 0.0075,
        //                           ),
        //                           decoration: BoxDecoration(
        //                             borderRadius: BorderRadius.circular(width * 0.01),
        //                             color: const Color(0xFF0E0E0E),
        //                           ),
        //                           child: Row(
        //                             children: [
        //                               ClipRRect(
        //                                 borderRadius: BorderRadius.circular(width * 0.01),
        //                                 child: ImageWidget(
        //                                   id: song.id,
        //                                   child: ClipRect(
        //                                     child: BackdropFilter(
        //                                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        //                                       child: Container(
        //                                         color: Colors.black.withOpacity(0.3),
        //                                         alignment: Alignment.center,
        //                                         child: IconButton(
        //                                           onPressed: (){
        //                                             songs.value.removeAt(index);
        //                                             songs.value = List.from(songs.value);
        //                                             widget.playlist.paths.removeAt(index);
        //                                           },
        //                                           icon: Icon(
        //                                             FluentIcons.trash,
        //                                             color: Colors.white,
        //                                             size: height * 0.02,
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 )
        //                               ),
        //                               SizedBox(
        //                                 width: width * 0.01,
        //                               ),
        //                               Column(
        //                                   mainAxisAlignment: MainAxisAlignment.center,
        //                                   crossAxisAlignment: CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(
        //                                         song.title.toString().length > 60 ? "${song.title.toString().substring(0, 60)}..." : song.title.toString(),
        //                                         style: TextStyle(
        //                                           color: Colors.white,
        //                                           fontSize: normalSize,
        //                                         )
        //                                     ),
        //                                     SizedBox(
        //                                       height: height * 0.001,
        //                                     ),
        //                                     Text(song.artist.toString().length > 60 ? "${song.artist.toString().substring(0, 60)}..." : song.artist.toString(),
        //                                         style: TextStyle(
        //                                           color: Colors.white,
        //                                           fontSize: smallSize,
        //                                         )
        //                                     ),
        //                                   ]
        //                               ),
        //                               const Spacer(),
        //                               Text(
        //                                   song.duration == null || song.duration == 0 ? "??:??" : "${song.duration! ~/ 60}:${(song.duration! % 60).toString().padLeft(2, '0')}",
        //                                   style: TextStyle(
        //                                     color: Colors.white,
        //                                     fontSize: normalSize,
        //                                   )
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       );
        //                     },
        //                     itemCount: widget.playlist.paths.length,
        //                     onReorder: (int oldIndex, int newIndex) {
        //                       if (oldIndex < newIndex) {
        //                         newIndex -= 1;
        //                       }
        //                       var temp = widget.playlist.paths.removeAt(oldIndex);
        //                       widget.playlist.paths.insert(newIndex, temp);
        //                       var temp2 =  songs.value.removeAt(oldIndex);
        //                       songs.value.insert(newIndex, temp2);
        //                       DataController.playlistBox.put(widget.playlist);
        //                     },
        //                   );
        //                 }
        //             ),
        //
        //           );
        //         },
        //       ),
        //     ),
        //     ValueListenableBuilder(
        //         valueListenable: editMode,
        //         builder: (context, value, child){
        //           return IconButton(
        //             onPressed: (){
        //               print("Edit ${widget.playlist.name}");
        //               if(editMode.value == false){
        //                 editMode.value = true;
        //               }
        //               else{
        //                 editMode.value = false;
        //                 DataController.playlistBox.put(widget.playlist);
        //               }
        //             },
        //             icon: Icon(
        //               value ? FluentIcons.editOff : FluentIcons.editOn,
        //               size: height * 0.02,
        //               color: Colors.white,
        //             ),
        //           );
        //         }
        //     ),
        //
        //   ],
        // ),
      ),
    );
  }
}