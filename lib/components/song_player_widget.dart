import 'package:flutter/material.dart';
import 'package:musicplayerandroid/components/player_tabs/details_tab.dart';
import 'package:musicplayerandroid/components/player_tabs/lyrics_tab.dart';
import 'package:musicplayerandroid/components/player_tabs/queue_tab.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/utils/fluenticons/fluenticons.dart';
import 'package:musicplayerandroid/utils/progress_bar/audio_video_progress_bar.dart';
import 'package:musicplayerandroid/utils/text_scroll/text_scroll.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SongPlayerWidget extends StatefulWidget {
  const SongPlayerWidget({super.key});

  @override
  _SongPlayerWidgetState createState() => _SongPlayerWidgetState();
}

class _SongPlayerWidgetState extends State<SongPlayerWidget> with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 1);

  late LocalDataProvider localDataProvider;
  late PageProvider pageProvider;
  late InfoProvider infoProvider;

  @override
  Widget build(BuildContext context) {
    localDataProvider = Provider.of<LocalDataProvider>(context, listen: false);
    pageProvider = Provider.of<PageProvider>(context, listen: true);
    infoProvider = Provider.of<InfoProvider>(context, listen: true);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    if (infoProvider.currentSongModel.getMap.isEmpty) {
      return const SizedBox();
    }
    return SlidingUpPanel(
      minHeight: height * 0.075,
      maxHeight: height * 0.9,
      controller: pageProvider.playerController,
      margin: pageProvider.minimized
          ? EdgeInsets.only(
              bottom: height * 0.01,
              left: width * 0.025,
              right: width * 0.025,
            )
          : EdgeInsets.zero,
      borderRadius: BorderRadius.circular(width * 0.1),
      color: const Color(0xFF0E0E0E),
      collapsed: buildMinimizedPlayer(width, height),
      panel: buildMaximizedPlayer(width, height),
      onPanelOpened: () {
        pageProvider.minimized = false;
      },
      onPanelClosed: () {
        pageProvider.minimized = true;
      },
    );
  }

  Widget buildPlayerButtons(double width, double height) {
    return Consumer<AudioProvider>(
      builder: (_, audioProvider, __){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await audioProvider.skipToPrevious();
              },
              icon: Icon(
                FluentIcons.previous,
                color: Colors.white,
                size: height * 0.022,
              ),
            ),
            IconButton(
              onPressed: () async {
                //print("pressed pause play");
                if (infoProvider.currentAudioInfo.playing) {
                  await audioProvider.pause();
                } else {
                  await audioProvider.play();
                }
              },
              icon: Icon(
                infoProvider.currentAudioInfo.playing
                    ? FluentIcons.pause
                    : FluentIcons.play,
                color: Colors.white,
                size: height * 0.03,
              ),
            ),
            IconButton(
              onPressed: () async {
                await audioProvider.skipToNext();
              },
              icon: Icon(
                FluentIcons.next,
                color: Colors.white,
                size: height * 0.025,
              ),
            ),
          ],
        );
      },
    );
  }


  Widget buildMinimizedPlayer(double width, double height) {
    return Container(
      key: const ValueKey("Minimized"),
      height: MediaQuery.of(context).size.height * 0.075,
      width: width * 0.95,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: infoProvider.darkColor,
        borderRadius: BorderRadius.circular(width * 0.1),
      ),
      child: GestureDetector(
        onTap: () {
          pageProvider.minimized = false;
          pageProvider.playerController.open();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: infoProvider.darkColor,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.memory(infoProvider.currentSongImage).image,
                    )
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextScroll(
                    infoProvider.currentSongModel.title.toString(),
                    mode: TextScrollMode.endless,
                    velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    delayBefore: const Duration(seconds: 2),
                    pauseBetween: const Duration(seconds: 2),
                  ),
                  TextScroll(
                    infoProvider.currentSongModel.artist ?? "Unknown",
                    mode: TextScrollMode.bouncing,
                    pauseOnBounce: const Duration(seconds: 1),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    delayBefore: const Duration(seconds: 1),
                    pauseBetween: const Duration(seconds: 1),
                  ),
                ],
              ),
            ),
            const Spacer(),
            buildPlayerButtons(width, height),

          ],
        ),
      ),
    );
  }

  Widget buildMaximizedPlayer(double width, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      key: const ValueKey("Maximized"),
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.005,
      ),
      color: const Color(0xFF0E0E0E).withOpacity(pageProvider.minimized ? 0.0 : 1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  pageProvider.minimized = true;
                  pageProvider.playerController.close();
                  print("Minimize");
                },
                icon: Icon(
                  FluentIcons.down,
                  color: Colors.white,
                  size: width * 0.05,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  print("options");
                },
                icon: Icon(
                  FluentIcons.moreVertical,
                  color: Colors.white,
                  size: width * 0.05,
                ),
              ),

            ],
          ),
          SizedBox(
            height: height * 0.5,
            child: PageView(
              onPageChanged: (int index){
                pageProvider.playerWidgetCurrentPage = index;
              },
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              children: [
                QueueTab(),
                DetailsTab(),
                LyricsTab(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: FutureBuilder(
              future: AudioProvider().getCurrentSongDuration(),
              builder: (context, snapshot){
                return Consumer<AudioProvider>(
                  builder: (_, audioProvider, __){
                    return ProgressBar(
                      progress: Duration(milliseconds: infoProvider.currentAudioInfo.slider),
                      total: snapshot.hasData ? Duration(milliseconds: snapshot.data!.inMilliseconds) : Duration.zero,
                      progressBarColor: infoProvider.lightColor,
                      baseBarColor: Colors.white.withOpacity(0.5),
                      bufferedBarColor: Colors.white.withOpacity(0.5),
                      thumbColor: Colors.white,
                      barHeight: 4.0,
                      thumbRadius: 7.0,
                      timeLabelLocation: TimeLabelLocation.sides,
                      timeLabelTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: height * 0.0175,
                        fontFamily: 'Bahnschrift',
                        fontWeight: FontWeight.normal,
                      ),
                      onSeek: (duration) {
                        audioProvider.seek(duration);
                      },
                    );
                  },
                );

              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!pageProvider.minimized)
                IconButton(
                  onPressed: () {
                    infoProvider.shuffle = !infoProvider.shuffle;
                  },
                  icon: Icon(
                    infoProvider.shuffle == false
                        ? FluentIcons.shuffleOff
                        : FluentIcons.shuffleOn,
                    size: height * 0.025,
                    color: Colors.white,
                  ),
                ),
              buildPlayerButtons(width, height),
              if (!pageProvider.minimized)
                IconButton(
                  onPressed: () {
                    infoProvider.repeat = !infoProvider.repeat;
                  },
                  icon: Icon(
                    infoProvider.repeat == false
                        ? FluentIcons.repeatOff
                        : FluentIcons.repeatOn,
                    size: height * 0.025,
                    color: Colors.white,
                  ),
                ),
            ],
          ),

        ],
      ),
    );
  }
}
