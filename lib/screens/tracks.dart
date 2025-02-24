import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/custom_buttons/add_all_button.dart';
import 'package:musicplayerandroid/components/text_scroll_with_gradient.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';
import 'package:musicplayerandroid/utils/extensions.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:musicplayerandroid/components/tiles/grid_tile.dart' as tiles;
import '../../providers/local_data_provider.dart';
import '../../utils/fluenticons/fluenticons.dart';

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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracks'),
        actions: [
          const AddAllButton(),
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
                  top: height * 0.01,
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
                      SelectionProvider selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
                      if (selectionProvider.selected.isNotEmpty){
                        selectionProvider.clear();
                        return;
                      }
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
                              padding: EdgeInsets.all(width * 0.01),
                              itemCount: snapshot.data!.length,
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: width * 0.425,
                                crossAxisSpacing: width * 0.02,
                                mainAxisSpacing: width * 0.02,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                SongModel song = snapshot.data![index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(width * 0.025),
                                  child: tiles.GridTile(
                                    onTap: () async {
                                      SelectionProvider selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
                                      if (selectionProvider.selected.isNotEmpty){
                                        if (selectionProvider.contains(song.id)){
                                          selectionProvider.remove(song.id);
                                          return;
                                        }
                                        selectionProvider.add(song.id, song.data);
                                        return;
                                      }
                                      AudioProvider audioProvider = Provider.of<AudioProvider>(context, listen: false);
                                      InfoProvider infoProvider = Provider.of<InfoProvider>(context, listen: false);
                                      try {
                                        if (infoProvider.currentSongPath != song.data) {
                                          List<String> songPaths = [];
                                          for (int i = 0; i < snapshot.data!.length; i++) {
                                            songPaths.add(snapshot.data![i].data);
                                          }
                                          if (infoProvider.unshuffledQueue.equals(songPaths) == false) {
                                            print("Updating playing songs");
                                            infoProvider.updatePlaying(songPaths, index);
                                          }
                                          infoProvider.index = infoProvider.currentQueue.indexOf(song.data);
                                          await audioProvider.play();
                                        }
                                        else {
                                          if (infoProvider.playing == true) {
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
                                        infoProvider.updatePlaying(songPaths, index);
                                        infoProvider.index = index;
                                        await audioProvider.play();
                                      }
                                    },
                                    onLongPress: (){
                                      print("Long pressed");
                                      SelectionProvider().add(song.id, song.data);
                                    },
                                    id: song.id,
                                    type: ArtworkType.AUDIO,
                                    unselectedOverlay: Consumer<InfoProvider>(
                                      builder: (context, infoProvider, child){
                                        return TextScrollWithGradient(
                                          text: song.title,
                                          style: TextStyle(
                                            color: infoProvider.currentSongPath == song.data ? Colors.blue : Colors.white,
                                            fontSize: smallSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                    selectedOverlay: ClipRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.3),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            FluentIcons.check,
                                            size: height * 0.1,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
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
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

}