import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/entities/playlist_entity.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/interface/screens/playlist_screen.dart';
import 'package:provider/provider.dart';
import '../../utils/fluenticons/fluenticons.dart';

import '../components/image_widget.dart';
import 'create_screen.dart';

class Playlists extends StatefulWidget{
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const Playlists(),
    );
  }
  const Playlists({super.key});

  @override
  _PlaylistsState createState() => _PlaylistsState();
}


class _PlaylistsState extends State<Playlists>{
  FocusNode searchNode = FocusNode();
  String value = '';
  Timer? _debounce;
  late Future<List<PlaylistEntity>> playlistsFuture;
  late LocalDataProvider localDataProvider;

  @override
  void initState(){
    super.initState();

  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        value = query;
        playlistsFuture = localDataProvider.getPlaylists(query);
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
    localDataProvider = Provider.of<LocalDataProvider>(context, listen: true);
    playlistsFuture = localDataProvider.getPlaylists('');
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Scaffold(
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
              child: FutureBuilder(
                  future: playlistsFuture,
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
                              "Error loading playlists",
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
                      return GridView.builder(
                        padding: EdgeInsets.only(
                          left: width * 0.01,
                          right: width * 0.01,
                          top: height * 0.01,
                          bottom: width * 0.125,
                        ),
                        itemCount: snapshot.data!.length + 1,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 0.825,
                          maxCrossAxisExtent: width * 0.425,
                          crossAxisSpacing: width * 0.0125,
                          //mainAxisSpacing: width * 0.0125,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          PlaylistEntity playlist = PlaylistEntity();
                          if (index > 0){
                            playlist = snapshot.data![index-1];
                          }
                          return index == 0 ?
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: (){
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScreen(name: value,)));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(width * 0.01),
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: Image.asset("assets/create_playlist.png").image,
                                            )
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Text(
                                    "Create a new playlist",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        height: 1,
                                        color: Colors.white,
                                        fontSize: smallSize,
                                        fontWeight: FontWeight.normal
                                    ),
                                  )
                                ],
                              ),

                            ),

                          ) :
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                //print(playlist.name);
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistScreen(playlist: playlist)));
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(width * 0.01),
                                    child: ImageWidget(
                                      path: playlist.paths.first,
                                      heroTag: playlist.name,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.005,
                                  ),
                                  Text(
                                    playlist.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      height: 1,
                                      color: Colors.white,
                                      fontSize: smallSize,
                                      fontWeight: FontWeight.normal,
                                    ),
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
        ),
        ),
      ),
    );

  }

}