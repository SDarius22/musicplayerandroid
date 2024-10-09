import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/screens/add_screen.dart';
import 'package:musicplayerandroid/screens/image_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controller/controller.dart';
import 'album_screen.dart';

class Tracks extends StatefulWidget{
  final Controller controller;
  const Tracks({super.key, required this.controller});

  @override
  _TracksState createState() => _TracksState();
}


class _TracksState extends State<Tracks>{

  FocusNode searchNode = FocusNode();

  Timer? _debounce;

  late Future<List<SongModel>> songsFuture;

  @override
  void initState(){
    super.initState();
    songsFuture = widget.controller.getSongs('');
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        songsFuture = widget.controller.getSongs(query);
      });
    });
  }


  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var boldSize = height * 0.015;
    var normalSize = height * 0.0125;
    var smallSize = height * 0.01;
    return Column(
      children: [
        Container(
          height: height * 0.05,
          margin: EdgeInsets.only(
            left: width * 0.025,
            right: width * 0.025,
            bottom: height * 0.01,
          ),
          alignment: Alignment.center,
          child: TextFormField(
            initialValue: '',
            focusNode: searchNode,
            onChanged: _onSearchChanged,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontSize: normalSize,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(height * 0.02),
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
              ),
              contentPadding: EdgeInsets.only(
                left: width * 0.025,
                right: width * 0.025,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: smallSize,
              ),
              labelText: 'Search', suffixIcon: Icon(FluentIcons.search_16_filled, color: Colors.white, size: height * 0.02,),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: songsFuture,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  print(snapshot.error);
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.error_circle_24_regular,
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
                  );
                }
                else if(snapshot.hasData){
                  if (snapshot.data!.isEmpty){
                    return Center(
                      child: Text("No songs found", style: TextStyle(color: Colors.white, fontSize: smallSize),),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.only(
                      left: width * 0.01,
                      right: width * 0.01,
                      top: height * 0.01,
                      bottom: width * 0.125,
                    ),
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 0.825,
                      maxCrossAxisExtent: width * 0.425,
                      crossAxisSpacing: width * 0.0125,
                      //mainAxisSpacing: width * 0.0125,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      SongModel song = snapshot.data![index];
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            //print("Playing ${widget.controller.indexNotifier.value}");
                            if (widget.controller.controllerQueue[widget.controller.indexNotifier.value] != song.data) {
                              //print("path match");
                              var songPaths = snapshot.data!.map((e) => e.data).toList();
                              if(widget.controller.settings.queue.equals(songPaths) == false){
                                print("Updating playing songs");
                                widget.controller.updatePlaying(songPaths, index);
                              }
                              widget.controller.indexChange(song.data);
                            }
                            await widget.controller.playSong();
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(width * 0.01),
                                child: ImageWidget(
                                  controller: widget.controller,
                                  id: song.id,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.005,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: widget.controller.indexNotifier,
                                  builder: (context, value, child){
                                    return Text(
                                      song.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1,
                                        color: widget.controller.controllerQueue.isNotEmpty && widget.controller.controllerQueue[widget.controller.indexNotifier.value] == song.id ? Colors.blue : Colors.white,
                                        fontSize: smallSize,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    );
                                  }
                              ),
                            ],
                          ),
                        ),

                      );

                    },
                  );
                }
                else{
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
              }
          ),
        ),
      ],
    );
  }

}