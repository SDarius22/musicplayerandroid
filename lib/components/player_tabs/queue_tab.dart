import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/image_widget.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/utils/text_scroll/text_scroll.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class QueueTab extends StatelessWidget {
  QueueTab({super.key});
  final ScrollController itemScrollController = ScrollController();
  late final AudioProvider audioProvider;
  late final LocalDataProvider localDataProvider;

  @override
  Widget build(BuildContext context) {
    try {
      audioProvider = Provider.of<AudioProvider>(context, listen: true);
      localDataProvider = Provider.of<LocalDataProvider>(context);
    } catch (e) {
      debugPrint("Error: $e");
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;

    return Scrollbar(
      controller: itemScrollController,
      thickness: 15.0,
      thumbVisibility: true,
      interactive: true,
      radius: const Radius.circular(10.0),
      child: ListView.builder(
        controller: itemScrollController,
        itemCount: audioProvider.currentAudioInfo.unshuffledQueue.length,
        prototypeItem: ListTile(
          title: const Text("Prototype"),
          subtitle: const Text("Prototype"),
          leading: ImageWidget(
            id: -1,
            heroTag: "prototype",
          ),
          trailing: const Text("0:00"),
        ),
        padding: EdgeInsets.only(
            right: width * 0.05
        ),
        itemBuilder: (context, int index) {
          return FutureBuilder(
            future: localDataProvider.getSong(audioProvider.currentAudioInfo.unshuffledQueue[index]),
            builder: (context, snapshot){
              if(snapshot.hasData){
                var song = snapshot.data as SongModel;
                return ListTile(
                  onTap: () async {
                    audioProvider.index = audioProvider.currentQueue.indexOf(audioProvider.currentAudioInfo.unshuffledQueue[index]);
                    await audioProvider.play();
                  },
                  leading: ImageWidget(
                    id: song.id,
                    heroTag: "${song.data} $index",
                  ),
                  title: Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                      return TextScroll(
                        song.title,
                        mode: TextScrollMode.bouncing,
                        velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                        style: TextStyle(
                          color: audioProvider.currentSongPath != song.data ? Colors.white : Colors.blue,
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                        ),
                        pauseOnBounce: const Duration(seconds: 2),
                        delayBefore: const Duration(seconds: 2),
                        pauseBetween: const Duration(seconds: 2),
                      );
                    },
                  ),
                  subtitle: Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                      return TextScroll(
                        song.artist ?? "Unknown",
                        mode: TextScrollMode.bouncing,
                        velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                        style: TextStyle(
                          color: audioProvider.currentSongPath != song.data ? Colors.white : Colors.blue,
                          fontSize: smallSize,
                          fontWeight: FontWeight.normal,
                        ),
                        pauseOnBounce: const Duration(seconds: 1),
                        delayBefore: const Duration(seconds: 1),
                        pauseBetween: const Duration(seconds: 1),
                      );
                    },
                  ),
                  trailing: Consumer<AudioProvider>(
                    builder: (context, audioProvider, child) {
                      return Text(
                        "${(song.duration! ~/ 1000 ~/ 60).toString().padLeft(2, '0')}"
                            ":${(song.duration! ~/ 1000 % 60).toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: audioProvider.currentSongPath != song.data ? Colors.white : Colors.blue,
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    },
                  ),
                );
              }
              else {
                return ListTile(
                  title: const Text("Loading..."),
                  subtitle: const Text("Loading..."),
                  leading: ImageWidget(
                    id: -1,
                    heroTag: "loading",
                  ),
                );
              }
            },
          );

        },
      ),
    );
  }
}