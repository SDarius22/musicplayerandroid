import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:musicplayerandroid/utils/lyric_reader/lyrics_reader.dart';
import 'package:provider/provider.dart';

class LyricsTab extends StatelessWidget {
  LyricsTab({super.key});
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

    return FutureBuilder(
        future: localDataProvider.getLyrics(audioProvider.currentSongModel.data),
        builder: (context, snapshot){
          if(snapshot.hasData){
            String plainLyric = snapshot.data![0];
            var lyricModel = LyricsModelBuilder.create().bindLyricToMain(snapshot.data![1]).getModel();
            return LyricsReader(
              model: lyricModel,
              position: audioProvider.currentAudioInfo.slider,
              lyricUi: UINetease(
                  defaultSize : 20,
                  defaultExtSize : 20,
                  otherMainSize : 20,
                  bias : 0.5,
                  lineGap : 5,
                  inlineGap : 5,
                  highlightColor: audioProvider.lightColor,
                  lyricAlign : LyricAlign.CENTER,
                  lyricBaseLine : LyricBaseLine.CENTER,
                  highlight : false
              ),
              playing: audioProvider.currentAudioInfo.playing,
              size: Size.infinite,
              padding: EdgeInsets.only(
                right: width * 0.02,
                left: width * 0.02,
              ),
              selectLineBuilder: (progress, confirm) {
                return Row(
                  children: [
                    Icon(FluentIcons.play, color: audioProvider.lightColor),
                    Expanded(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            confirm.call();
                            audioProvider.seek(Duration(milliseconds: progress));
                          },
                        ),
                      ),
                    ),
                    Text(
                      //progress.toString(),
                      "${progress ~/ 1000 ~/ 60}:${(progress ~/ 1000 % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(color: audioProvider.lightColor),
                    )
                  ],
                );
              },
              emptyBuilder: () => plainLyric.contains("No lyrics") || plainLyric.contains("Searching")?
              Center(
                  child: Text(
                    plainLyric,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: normalSize,
                      fontFamily: 'Bahnschrift',
                      fontWeight: FontWeight.normal,
                    ),
                  )
              ):
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        plainLyric,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: normalSize,
                          fontFamily: 'Bahnschrift',
                          fontWeight: FontWeight.normal,
                        ),
                      )
                  ),
                ),
              ),

            );
          }
          else {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            );
          }
        }
    );
  }
}