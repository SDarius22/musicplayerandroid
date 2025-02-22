import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/entities/playlist_entity.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../providers/local_data_provider.dart';
import '../../utils/fluenticons/fluenticons.dart';

//TODO: Recode this


class CreateScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const CreateScreen(name: '',),
    );
  }
  final List<String>? paths;
  final String name;
  const CreateScreen({super.key, this.paths, required this.name});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  List<SongModel> selected = [];
  String playlistName = "";
  String playlistAdd = "last";
  String search = "";
  FocusNode searchNode = FocusNode();
  FocusNode nameNode = FocusNode();

  late Future init;

  @override
  void initState() {
    playlistName = widget.name;
    super.initState();
    init = Future(() async {
      if (widget.paths != null && widget.paths!.isNotEmpty) {
        for (var path in widget.paths!) {
          debugPrint(path);
          var song = await LocalDataProvider().getSong(path);
          if (song.getMap.isNotEmpty){
            selected.add(song);
          }
        }
      }
    });
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
          "${widget.name.isEmpty ? "Create" : "Import"} Playlist",
          style: TextStyle(
              color: Colors.white,
              fontSize: boldSize,
              fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: (){
                if (playlistName.isEmpty) {
                  BotToast.showText(text: "Playlist name cannot be empty");
                  return;
                }
                if (selected.isEmpty) {
                  BotToast.showText(text: "No songs selected");
                  return;
                }
                PlaylistEntity newPlaylist = PlaylistEntity();
                newPlaylist.name = playlistName;
                newPlaylist.paths = selected.map((e) => e.data).toList();
                for (var song in selected) {
                  newPlaylist.duration += song.duration ?? 0;
                }
                newPlaylist.nextAdded = playlistAdd;
                LocalDataProvider().createPlaylist(newPlaylist);
                Navigator.pop(context);
              },
              child: Text(
                widget.name.isEmpty ? "Create" : "Import",
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
        child: FutureBuilder(
          future: init,
          builder: (context, notImportant) {
            if (notImportant.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  maxLength: 50,
                  initialValue: playlistName,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    hintText: 'Playlist name',
                    counterText: "",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: smallSize,
                    ),
                  ),
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: normalSize,
                  ),
                  onChanged: (value) {
                    playlistName = value;
                  },
                ),
                SizedBox(
                  height: height * 0.01,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Where to add new songs?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: normalSize
                      ),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                        value: playlistAdd,
                        icon: Icon(
                          FluentIcons.down,
                          color: Colors.white,
                          size: height * 0.025,
                        ),
                        style: TextStyle(
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        borderRadius: BorderRadius.circular(width * 0.01),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        items: const [
                          DropdownMenuItem(
                            value: 'first',
                            child: Text("At the beginning"),
                          ),
                          DropdownMenuItem(
                            value: 'last',
                            child: Text("At the end"),
                          ),
                        ],
                        onChanged: (String? newValue){
                          setState(() {
                            playlistAdd = newValue ?? 'last';
                          });
                        }
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(width * 0.01),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.02),
                    color: const Color(0xFF242424),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: searchNode,
                        onChanged: (value){
                          setState(() {
                            search = value;
                          });
                        },
                        cursorColor: Colors.white,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalSize,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.02),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: smallSize,
                            ),
                            labelText: 'Search', suffixIcon: Icon(FluentIcons.search, color: Colors.white, size: height * 0.02,)
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        height: height * 0.57,
                        child: FutureBuilder(
                            future: LocalDataProvider().getSongs(search, 50),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                List<SongModel> songs = snapshot.data ?? [];
                                return songs.isNotEmpty ?
                                ListView.builder(
                                  itemCount: songs.length,
                                  itemExtent: height * 0.125,
                                  itemBuilder: (context, int index) {
                                    var song = songs[index];
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                      height: height * 0.125,
                                      padding: EdgeInsets.only(right: width * 0.01),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: (){
                                            print("Tapped on $index");
                                            setState(() {
                                              selected.contains(song) ? selected.remove(song) : selected.add(song);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(width * 0.005),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(width * 0.01),
                                              color: const Color(0xFF0E0E0E),
                                            ),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(width * 0.01),
                                                    child: FutureBuilder(
                                                      future: LocalDataProvider().getImage(song.id),
                                                      builder: (context, snapshot) {
                                                        return AspectRatio(
                                                          aspectRatio: 1.0,
                                                          child: snapshot.hasData?
                                                          Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors.black,
                                                                    image: DecorationImage(
                                                                      fit: BoxFit.cover,
                                                                      image: Image.memory(snapshot.data!).image,
                                                                    )
                                                                ),
                                                              ),
                                                              if(selected.contains(song))
                                                                BackdropFilter(
                                                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    child: Icon(
                                                                      FluentIcons.check,
                                                                      size: height * 0.03,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ) :
                                                          snapshot.hasError?
                                                          Center(
                                                            child: Text(
                                                              '${snapshot.error} occurred',
                                                              style: const TextStyle(fontSize: 18),
                                                            ),
                                                          ) :
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.black,
                                                                image: DecorationImage(
                                                                  fit: BoxFit.cover,
                                                                  image: Image.asset("assets/logo.png").image,
                                                                )
                                                            ),
                                                            child: const Center(
                                                              child: CircularProgressIndicator(
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                ),
                                                SizedBox(
                                                  width: width * 0.005,
                                                ),
                                                Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                          song.title.toString().length > 30 ? "${song.title.toString().substring(0, 30)}..." : song.title.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: normalSize,
                                                          )
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.001,
                                                      ),
                                                      Text(song.artist.toString().length > 30 ? "${song.artist.toString().substring(0, 30)}..." : song.artist.toString(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: smallSize,
                                                          )
                                                      ),
                                                    ]
                                                ),
                                                const Spacer(),
                                                Text(
                                                    song.duration == null || song.duration == 0 ? "??:??" : "${song.duration! ~/ 60}:${(song.duration! % 60).toString().padLeft(2, '0')}",
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
                                    );
                                  },
                                ) :
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: normalSize
                                  ),
                                );
                              }
                              else if(snapshot.hasError){
                                return Center(
                                  child: Text(
                                    "Error occured. Try again later.",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: normalSize,
                                    ),
                                  ),
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

              ],
            );
          },
        ),

      ),
    );
  }
}