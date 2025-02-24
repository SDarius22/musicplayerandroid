import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/custom_buttons/add_all_button.dart';
import 'package:musicplayerandroid/components/text_scroll_with_gradient.dart';
import 'package:musicplayerandroid/components/tiles/grid_tile.dart' as tiles;
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../utils/fluenticons/fluenticons.dart';
import 'album_screen.dart';


class Albums extends StatefulWidget{
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const Albums(),
    );
  }
  const Albums({super.key});

  @override
  _AlbumsState createState() => _AlbumsState();
}


class _AlbumsState extends State<Albums>{
  FocusNode searchNode = FocusNode();
  Timer? _debounce;
  late Future<List<AlbumModel>> albumsFuture;
  late LocalDataProvider localDataProvider;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty){
          albumsFuture = localDataProvider.getAlbums('');
          return;
        }
        albumsFuture = localDataProvider.getAlbums(query, 25);
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
    localDataProvider = LocalDataProvider();
    albumsFuture = localDataProvider.getAlbums('');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        actions: [
          // const AddAllButton(),
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
                  onTap: () {
                    SelectionProvider selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
                    if (selectionProvider.selected.isNotEmpty){
                      selectionProvider.clear();
                      return;
                    }
                  },
                  child: FutureBuilder(
                      future: albumsFuture,
                      builder: (context, snapshot){
                        if(snapshot.hasError){
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FluentIcons.error,
                                  size: height * 0.1,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Error loading albums",
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
                              child: Text("No albums found.", style: TextStyle(color: Colors.white, fontSize: smallSize),),
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
                              AlbumModel album = snapshot.data![index];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(width * 0.025),
                                child: tiles.GridTile(
                                  onTap: () async {
                                    SelectionProvider selectionProvider = Provider.of<SelectionProvider>(context, listen: false);
                                    if (selectionProvider.selected.isNotEmpty){
                                      if (selectionProvider.contains(album.id)){
                                        selectionProvider.remove(album.id);
                                        return;
                                      }
                                      selectionProvider.add(album.id, album.album);
                                      return;
                                    }
                                    PageProvider().navigatorKey.currentState!.push(
                                        MaterialPageRoute(
                                            builder: (context) => AlbumScreen(album: album,)
                                        )
                                    );
                                  },
                                  onLongPress: (){
                                    print("Long pressed");
                                    SelectionProvider().add(album.id, album.album);
                                  },
                                  id: album.id,
                                  type: ArtworkType.ALBUM,
                                  unselectedOverlay: TextScrollWithGradient(
                                    text: album.album,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: smallSize,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              // return  MouseRegion(
                              //   cursor: SystemMouseCursors.click,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       PageProvider().navigatorKey.currentState!.push(
                              //           MaterialPageRoute(
                              //               builder: (context) => AlbumScreen(album: album,)
                              //           )
                              //       );
                              //     },
                              //     child: Column(
                              //       children: [
                              //         ClipRRect(
                              //           borderRadius: BorderRadius.circular(width * 0.01),
                              //           child: Hero(
                              //             tag: album.album,
                              //             child: FutureBuilder(
                              //               future: localDataProvider.audioQuery.queryArtwork(album.id, ArtworkType.ALBUM),
                              //               builder: (context, snapshot){
                              //                 return AspectRatio(
                              //                   aspectRatio: 1.0,
                              //                   child: snapshot.hasData?
                              //                   Container(
                              //                     decoration: BoxDecoration(
                              //                         color: Colors.black,
                              //                         image: DecorationImage(
                              //                           fit: BoxFit.cover,
                              //                           image: Image.memory(snapshot.data!).image,
                              //                         )
                              //                     ),
                              //                   ):
                              //                   Container(
                              //                     decoration: BoxDecoration(
                              //                         color: Colors.black,
                              //                         image: DecorationImage(
                              //                           fit: BoxFit.cover,
                              //                           image: Image.asset("assets/logo.png").image,
                              //                         )
                              //                     ),
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //           ),
                              //         ),
                              //
                              //         SizedBox(
                              //           height: width * 0.005,
                              //         ),
                              //         Text(
                              //           album.album,
                              //           maxLines: 2,
                              //           overflow: TextOverflow.ellipsis,
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             height: 1,
                              //             color: Colors.white,
                              //             fontSize: smallSize,
                              //             fontWeight: FontWeight.normal,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              //
                              // );

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
              )
            ],
          ),
        ),
      ),
    );

  }

}