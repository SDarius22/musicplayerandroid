import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/utils/extensions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../providers/local_data_provider.dart';
import '../../utils/fluenticons/fluenticons.dart';
import '../components/image_widget.dart';

class Tracks extends StatefulWidget{
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const Tracks(),
    );
  }
  const Tracks({super.key});

  @override
  _TracksState createState() => _TracksState();
}


class _TracksState extends State<Tracks>{
  FocusNode searchNode = FocusNode();
  Timer? _debounce;
  late Future songsFuture = LocalDataProvider().getSongs('');
  late AudioProvider audioProvider;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty){
          songsFuture = LocalDataProvider().getSongs('');
          return;
        }
        songsFuture = LocalDataProvider().getSongs(query, 25);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    songsFuture = LocalDataProvider().getSongs('');
  }


  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    audioProvider = Provider.of<AudioProvider>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
        actions: [
          IconButton(
            icon: const Icon(FluentIcons.menu),
            onPressed: () {
              Scaffold.of(PageProvider().navigatorKey.currentContext!).openEndDrawer();
            },
          ),
        ],
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
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
                    labelText: 'Search', suffixIcon: Icon(FluentIcons.search, color: Colors.white, size: height * 0.02,),
                  ),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: (){
                      // if (localDataProvider.selectedPaths.isNotEmpty){
                      //   localDataProvider.selectedPaths = [];
                      // }
                    },
                    child: FutureBuilder(
                        future: songsFuture,
                        builder: (context, snapshot){
                          if(snapshot.hasData){
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
                                return InkWell(
                                  borderRadius: BorderRadius.circular(width * 0.01),
                                  onTap: () async {
                                    // if (localDataProvider.selectedPaths.isNotEmpty){
                                    //   if (localDataProvider.selectedPaths.contains(song.data)){
                                    //     localDataProvider.selectedPaths.remove(song.data);
                                    //     return;
                                    //   }
                                    //   localDataProvider.selectedPaths.add(song.data);
                                    //   return;
                                    // }
                                    try {
                                      if (audioProvider.currentSongPath != song.data) {
                                        List<String> songPaths = [];
                                        for (int i = 0; i < snapshot.data!.length; i++) {
                                          songPaths.add(snapshot.data![i].data);
                                        }
                                        if (audioProvider.currentAudioInfo.unshuffledQueue.equals(songPaths) == false) {
                                          print("Updating playing songs");
                                          audioProvider.updatePlaying(songPaths, index);
                                        }
                                        audioProvider.index = audioProvider.currentQueue.indexOf(song.data);
                                        await audioProvider.play();
                                      }
                                      else {
                                        if (audioProvider.currentAudioInfo.playing == true) {
                                          await audioProvider.pause();
                                        }
                                        else {
                                          await audioProvider.play();
                                        }
                                      }
                                    }
                                    catch (e) {
                                      print(e);
                                      List<String> songPaths = [];
                                      for (int i = 0; i < snapshot.data!.length; i++) {
                                        songPaths.add(snapshot.data![i].data);
                                      }
                                      audioProvider.updatePlaying(songPaths, index);
                                      audioProvider.index = index;
                                      await audioProvider.play();
                                    }
                                  },
                                  onLongPress: (){
                                    print("Long pressed");
                                    // localDataProvider.selectedPaths.add(song.data);
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(width * 0.01),
                                        child: ImageWidget(
                                          id: song.id,
                                          heroTag: song.data,
                                          // child: ValueListenableBuilder(
                                          //   valueListenable: localDataProvider.selectedPaths,
                                          //   builder: (context, value, child){
                                          //     return value.isNotEmpty && value.contains(song.data) ? ClipRect(
                                          //       child: BackdropFilter(
                                          //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          //         child: Container(
                                          //           color: Colors.black.withOpacity(0.3),
                                          //           alignment: Alignment.center,
                                          //           child: Icon(
                                          //             FluentIcons.check,
                                          //             size: height * 0.1,
                                          //             color: Colors.white,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ) : const SizedBox();
                                          //   },
                                          // ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.005,
                                      ),
                                      Consumer<AudioProvider>(
                                        builder: (context, audioProvider, child){
                                          return Text(
                                            song.title,
                                            style: TextStyle(
                                              color: audioProvider.currentSongPath == song.data ? Colors.blue : Colors.white,
                                              fontSize: smallSize,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          );
                                        },
                                      ),
                                    ],
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
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}