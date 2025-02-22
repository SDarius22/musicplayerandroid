import 'dart:async';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../providers/local_data_provider.dart';
import '../../utils/fluenticons/fluenticons.dart';
import 'artist_screen.dart';

class Artists extends StatefulWidget{
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const Artists(),
    );
  }
  const Artists({super.key});

  @override
  _ArtistsState createState() => _ArtistsState();
}


class _ArtistsState extends State<Artists>{
  FocusNode searchNode = FocusNode();
  Timer? _debounce;
  late Future<List<ArtistModel>> artistsFuture;
  late LocalDataProvider localDataProvider;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if (query.isEmpty){
          artistsFuture = localDataProvider.getArtists('');
          return;
        }
        artistsFuture = localDataProvider.getArtists(query, 25);
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
    localDataProvider = Provider.of<LocalDataProvider>(context);
    artistsFuture = localDataProvider.getArtists('');
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
                    future: artistsFuture,
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
                                "Error loading artists",
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
                            child: Text("No artists found.", style: TextStyle(color: Colors.white, fontSize: smallSize),),
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
                            ArtistModel artist = snapshot.data![index];
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  //print(artist.name);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistScreen(artist: artist)));
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(width * 0.01),
                                      child: Hero(
                                        tag: artist.artist,
                                        child: FutureBuilder(
                                          future: localDataProvider.audioQuery.queryArtwork(artist.id, ArtworkType.ARTIST),
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
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: width * 0.005,
                                    ),
                                    Text(
                                      artist.artist,
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