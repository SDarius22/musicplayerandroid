import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/utils/hover_widget/hover_container.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../controller/app_manager.dart';
import '../../controller/audio_player_controller.dart';
import '../../controller/data_controller.dart';
import '../../controller/settings_controller.dart';
import '../../controller/worker_controller.dart';
import '../../main.dart';
import '../../utils/fluenticons/fluenticons.dart';
import '../../utils/multivaluelistenablebuilder/mvlb.dart';
import '../../utils/lyric_reader/lyrics_reader.dart';
import '../../utils/progress_bar/audio_video_progress_bar.dart';
import '../../utils/text_scroll/text_scroll.dart';
import 'image_widget.dart';
import 'package:flutter/foundation.dart';


class SongPlayerWidget extends StatefulWidget {
  const SongPlayerWidget({super.key});

  @override
  _SongPlayerWidgetState createState() => _SongPlayerWidgetState();
}

class _SongPlayerWidgetState extends State<SongPlayerWidget> with TickerProviderStateMixin {
  late ScrollController itemScrollController;
  late Future songFuture;
  var lyricUI = UINetease(
      defaultSize : 20,
      defaultExtSize : 20,
      otherMainSize : 20,
      bias : 0.5,
      lineGap : 5,
      inlineGap : 5,
      highlightColor: Colors.blue,
      lyricAlign : LyricAlign.CENTER,
      lyricBaseLine : LyricBaseLine.CENTER,
      highlight : false
  );

  late AnimationController _controller;
  late Animation<double> _animation;
  final double minHeight = 0.085;
  final double maxHeight = 1.0;
  final double snapThreshold = 0.05;
  double currentSize = 0.085;

  int currentPage = 1;
  final PageController _pageController = PageController(initialPage: 1);



  @override
  void initState() {
    songFuture = Future(() async {
      SongModel song = SongModel({});
      try {
        song = await DataController.getSong(SettingsController.currentSongPath);
      } catch (e) {
        print(e);
      }
      return song;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController = ScrollController();
    });
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: minHeight, end: maxHeight).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.addListener(() {
      setState(() {
        currentSize = _animation.value;
      });
    });
    SettingsController.lightColorNotifier.addListener(() {
      setState(() {
        lyricUI = UINetease(
            defaultSize : MediaQuery.of(context).size.height * 0.022,
            defaultExtSize : MediaQuery.of(context).size.height * 0.020,
            otherMainSize : MediaQuery.of(context).size.height * 0.020,
            bias : 0.5,
            lineGap : 5,
            inlineGap : 5,
            highlightColor: SettingsController.lightColorNotifier.value,
            lyricAlign : LyricAlign.CENTER,
            lyricBaseLine : LyricBaseLine.CENTER,
            highlight : false
        );
      });
    });
    SettingsController.indexNotifier.addListener((){
      print(SettingsController.currentSongPath);
      setState(() {
        songFuture = Future(() async {
          SongModel song = SongModel({});
          try {
            song = await DataController.getSong(SettingsController.currentSongPath);
          } catch (e) {
            print(e);
          }
          return song;
        });

      });
    });
  }

  @override
  void dispose() {
    itemScrollController.dispose();
    SettingsController.lightColorNotifier.removeListener(() {});
    SettingsController.indexNotifier.removeListener(() {});
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final dc = DataController();
    final am = AppManager();
    final apc = AudioPlayerController();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.018;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    lyricUI = UINetease(
        defaultSize : MediaQuery.of(context).size.height * 0.022,
        defaultExtSize : MediaQuery.of(context).size.height * 0.020,
        otherMainSize : MediaQuery.of(context).size.height * 0.020,
        bias : 0.5,
        lineGap : 5,
        inlineGap : 5,
        highlightColor: SettingsController.lightColorNotifier.value,
        lyricAlign : LyricAlign.CENTER,
        lyricBaseLine : LyricBaseLine.CENTER,
        highlight : false
    );
    return ValueListenableBuilder(
        valueListenable: am.minimizedNotifier,
        builder: (context, minimizedVal, child){
          return FutureBuilder(
              future: songFuture,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  print(snapshot.error);
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
                          "Error loading song",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: smallSize,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              // songFuture = widget.controller.getSong(widget.controller.controllerQueue[0]);
                            });
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
                if(snapshot.hasData){
                  SongModel currentSong = snapshot.data;
                  print(currentSong.id);
                  if (currentSong.getMap.isEmpty) {
                    return const SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      if (minimizedVal) {
                        _animation = Tween<double>(begin: currentSize, end: maxHeight).animate(CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut,
                        ));
                        am.minimizedNotifier.value = false;
                        _controller.forward(from: 0);
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        currentSize -= details.primaryDelta! / MediaQuery.of(context).size.height;
                        currentSize = currentSize.clamp(minHeight, maxHeight);
                      });
                    },
                    onVerticalDragEnd: (details) {
                      double dragDistance = (currentSize - minHeight).abs();
                      double screenFractionDragged = dragDistance / (maxHeight - minHeight);

                      // Determine snap direction based on drag velocity and distance
                      if (screenFractionDragged >= snapThreshold && details.primaryVelocity! < 0) {
                      // Snap up if the user dragged up, or if the drag velocity was upwards
                        print("Snap up");
                        _animation = Tween<double>(begin: currentSize, end: maxHeight).animate(CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut,
                        ));
                        am.minimizedNotifier.value = false;
                      }
                      // Snap down if the user dragged down, or if the drag velocity was downwards
                      else if (screenFractionDragged >= snapThreshold && details.primaryVelocity! > 0) {
                        print("Snap down");
                        _animation = Tween<double>(begin: currentSize, end: minHeight).animate(CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeOut,
                        ));
                        am.minimizedNotifier.value = true;
                      }
                      else {
                        print("Snap to closest point");
                        // If the drag distance was below the threshold, snap to the closest point
                        _animation = Tween<double>(begin: currentSize, end: currentSize > (minHeight + maxHeight) / 2 ? maxHeight : minHeight)
                            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
                      }

                      _controller.forward(from: 0);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.linear,
                      height: MediaQuery.of(context).size.height * currentSize,
                      width: width,
                      alignment: minimizedVal ? Alignment.centerLeft : Alignment.topCenter,
                      padding: EdgeInsets.only(
                        left: minimizedVal ? 1 : width * 0.005,
                        right: minimizedVal ? 1 : width * 0.005,
                        top: minimizedVal ? 1 : height * 0.05,
                        bottom: minimizedVal ? 1 : 0,
                      ),
                      margin: minimizedVal ? EdgeInsets.only(
                        left: width * 0.025,
                        right: width * 0.025,
                        bottom: width * 0.025,
                      ) : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: minimizedVal ? SettingsController.darkColorNotifier.value : const Color(0xFF0E0E0E),
                        borderRadius: minimizedVal ? BorderRadius.circular(width * 0.1) : BorderRadius.circular(0),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          if(!minimizedVal)
                            Row(
                              children: [
                                SizedBox(
                                  height: height * 0.025,
                                  width: height * 0.025,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _animation = Tween<double>(begin: currentSize, end: minHeight).animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: Curves.easeOut,
                                    ));
                                    am.minimizedNotifier.value = true;
                                    _controller.forward(from: 0);
                                    print("Minimize");
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                    size: width * 0.05,
                                  ),
                                ),
                              ],
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: minimizedVal ? height * 0.08 : width * 0.9,
                            width: minimizedVal ? height * 0.08 : width * 0.9,
                            margin: minimizedVal ? EdgeInsets.zero : EdgeInsets.only(
                              top: height * 0.025,
                              bottom: height * 0.01,
                            ),
                            child: PageView(
                              onPageChanged: (int index){
                                setState(() {
                                  currentPage = index;
                                });
                              },
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              scrollBehavior: ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: width * 0.85,
                                  width: width * 0.85,
                                  child: ListView.builder(
                                    controller: itemScrollController,
                                    itemCount: SettingsController.queue.length,
                                    padding: EdgeInsets.only(
                                        right: width * 0.01
                                    ),
                                    itemBuilder: (context, int index) {
                                      return FutureBuilder(
                                        future: DataController.getSong(SettingsController.queue[index]),
                                        builder: (context, snapshot){
                                          if(snapshot.hasData){
                                            var song = snapshot.data as SongModel;
                                            return AnimatedContainer(
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: height * 0.125,
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: () async {
                                                      //print(widget.controller.settings.playingSongsUnShuffled[index].title);
                                                      //widget.controller.audioPlayer.stop();
                                                      SettingsController.index = SettingsController.currentQueue.indexOf(SettingsController.queue[index]);
                                                      await audioHandler.play();
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(width * 0.01),
                                                      child: HoverContainer(
                                                        hoverColor: const Color(0xFF242424),
                                                        normalColor: const Color(0xFF0E0E0E),
                                                        padding: EdgeInsets.all(width * 0.005),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(width * 0.01),
                                                              child: ImageWidget(
                                                                id: song.id,
                                                                buttons: IconButton(
                                                                  onPressed: () async {
                                                                    print("Delete song from queue");
                                                                    await dc.removeFromQueue(SettingsController.queue[index]);
                                                                    setState(() {});
                                                                  },
                                                                  icon: Icon(
                                                                    FluentIcons.trash,
                                                                    color: Colors.white,
                                                                    size: width * 0.01,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width * 0.15,
                                                                    child: TextScroll(
                                                                      song.title,
                                                                      mode: TextScrollMode.bouncing,
                                                                      velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                      style: TextStyle(
                                                                        color: SettingsController.currentSongPath != song.data ? Colors.white : Colors.blue,
                                                                        fontSize: normalSize,
                                                                        fontFamily: 'Bahnschrift',
                                                                        fontWeight: FontWeight.normal,
                                                                      ),
                                                                      pauseOnBounce: const Duration(seconds: 2),
                                                                      delayBefore: const Duration(seconds: 2),
                                                                      pauseBetween: const Duration(seconds: 2),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: height * 0.005,
                                                                  ),
                                                                  Text(song.artist.toString().length > 60 ? "${song.artist.toString().substring(0, 60)}..." : song.artist.toString(),
                                                                      style: TextStyle(
                                                                        color: SettingsController.currentSongPath != song.data ? Colors.white : Colors.blue,
                                                                        fontSize: smallSize,
                                                                      )
                                                                  ),
                                                                ]
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                song.duration != null ? "${song.duration! ~/ 60000}:${(song.duration! % 60000).toString().padLeft(2, '0')}" : "0:00",
                                                                style: TextStyle(
                                                                  color: SettingsController.currentSongPath != song.data ? Colors.white : Colors.blue,
                                                                  fontSize: normalSize,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ),
                                            );
                                          }
                                          else {
                                            return AnimatedContainer(
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                              height: height * 0.125,
                                              child: MouseRegion(
                                                cursor: SystemMouseCursors.click,
                                                child: GestureDetector(
                                                    behavior: HitTestBehavior.translucent,
                                                    onTap: () async {
                                                      //print(widget.controller.settings.playingSongsUnShuffled[index].title);
                                                      //widget.controller.audioPlayer.stop();
                                                      SettingsController.index = SettingsController.currentQueue.indexOf(SettingsController.queue[index]);
                                                      await audioHandler.play();
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(width * 0.01),
                                                      child: HoverContainer(
                                                        hoverColor: const Color(0xFF242424),
                                                        normalColor: const Color(0xFF0E0E0E),
                                                        padding: EdgeInsets.all(width * 0.005),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(width * 0.01),
                                                              child: const ImageWidget(
                                                                id: -1,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.01,
                                                            ),
                                                            SizedBox(
                                                              width: width * 0.15,
                                                              child: TextScroll(
                                                                'Loading song details...',
                                                                mode: TextScrollMode.bouncing,
                                                                velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: normalSize,
                                                                  fontFamily: 'Bahnschrift',
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                                pauseOnBounce: const Duration(seconds: 2),
                                                                delayBefore: const Duration(seconds: 2),
                                                                pauseBetween: const Duration(seconds: 2),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                "??:??",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: normalSize,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );

                                    },
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  height: minimizedVal? height * 0.075  : width * 0.85,
                                  width: minimizedVal ? height * 0.075  : width * 0.85,
                                  //padding: EdgeInsets.all(width * 0.01),
                                  alignment: Alignment.center,
                                  //color: Colors.red,
                                  child: FutureBuilder(
                                      future: WorkerController.getImage(currentSong.id),
                                      builder: (context, snapshot2) {
                                        if(snapshot2.hasData) {
                                          apc.addSong(currentSong, snapshot2.data as Uint8List);
                                          return AspectRatio(
                                            aspectRatio: 1.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: minimizedVal ? BoxShape.circle : BoxShape.rectangle,
                                                  color: Colors.black,
                                                  borderRadius: minimizedVal ? null : BorderRadius.circular(width * 0.025),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.memory(snapshot2.data as Uint8List).image,
                                                  )
                                              ),
                                            ),
                                          );
                                        }
                                        return const CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        );
                                      }
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  height: minimizedVal? height * 0.075  : width * 0.85,
                                  width: minimizedVal ? height * 0.075  : width * 0.85,
                                  //padding: EdgeInsets.all(width * 0.01),
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                      future: DataController.getLyrics(currentSong.data),
                                      builder: (context, snapshot){
                                        if(snapshot.hasData){
                                          String plainLyric = snapshot.data![0];
                                          var lyricModel = LyricsModelBuilder.create().bindLyricToMain(snapshot.data![1]).getModel();
                                          return MultiValueListenableBuilder(
                                              valueListenables: [SettingsController.sliderNotifier, SettingsController.playingNotifier],
                                              builder: (context, value, child){
                                                return LyricsReader(
                                                  model: lyricModel,
                                                  position: value[0],
                                                  lyricUi: lyricUI,
                                                  playing: SettingsController.playing,
                                                  size: Size.infinite,
                                                  padding: EdgeInsets.only(
                                                    right: width * 0.02,
                                                    left: width * 0.02,
                                                  ),
                                                  selectLineBuilder: (progress, confirm) {
                                                    return Row(
                                                      children: [
                                                        Icon(FluentIcons.play, color: SettingsController.lightColorNotifier.value),
                                                        Expanded(
                                                          child: MouseRegion(
                                                            cursor: SystemMouseCursors.click,
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                confirm.call();
                                                                setState(() {
                                                                  AudioPlayerController.audioPlayer.seek(Duration(milliseconds: progress));
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          //progress.toString(),
                                                          "${progress ~/ 1000 ~/ 60}:${(progress ~/ 1000 % 60).toString().padLeft(2, '0')}",
                                                          style: TextStyle(color: SettingsController.lightColorNotifier.value),
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
                                          );
                                        }
                                        else if(snapshot.hasError){
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
                                                  "Error loading lyrics",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: smallSize,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      // lyricFuture = widget.controller.getLyrics(widget.controller.controllerQueue[widget.controller.indexNotifier.value]);
                                                    });
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
                                        else {
                                          return const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          );
                                        }
                                      }
                                  ),
                                ),

                              ],

                            ),
                          ),
                          Container(
                            width: minimizedVal ? width * 0.4 : width * 0.85,
                            height: height * 0.075,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.01,
                            ),
                            alignment: minimizedVal ? Alignment.centerLeft : Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: minimizedVal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                              children: [
                                TextScroll(
                                  currentSong.title.toString(),
                                  mode: TextScrollMode.endless,
                                  velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: boldSize,
                                    fontFamily: 'Bahnschrift',
                                    fontWeight: FontWeight.normal,
                                  ),
                                  delayBefore: const Duration(seconds: 2),
                                  pauseBetween: const Duration(seconds: 2),
                                ),
                                SizedBox(
                                  height: height * 0.001,
                                ),
                                TextScroll(
                                  currentSong.artist ?? "Unknown",
                                  mode: TextScrollMode.bouncing,
                                  pauseOnBounce: const Duration(seconds: 1),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: normalSize,
                                    fontFamily: 'Bahnschrift',
                                    fontWeight: FontWeight.normal,
                                  ),
                                  delayBefore: const Duration(seconds: 1),
                                  pauseBetween: const Duration(seconds: 1),
                                ),
                              ],
                            ),
                          ),
                          if(!minimizedVal)
                          //ProgressBar
                            MultiValueListenableBuilder(
                                valueListenables: [SettingsController.sliderNotifier, SettingsController.lightColorNotifier],
                                builder: (context, values, child){
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    width: am.minimizedNotifier.value ? width * 0.775 : width * 0.85,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: am.minimizedNotifier.value ? 0 : height * 0.03,
                                    ),
                                    child: FutureBuilder(
                                      future: DataController.getDuration(currentSong),
                                      builder: (context, snapshot){
                                        return ProgressBar(
                                          progress: Duration(milliseconds: values[0]),
                                          total: snapshot.hasData ? Duration(milliseconds: snapshot.data!.inSeconds) : Duration.zero,
                                          progressBarColor: values[1],
                                          baseBarColor: Colors.white.withOpacity(0.5),
                                          bufferedBarColor: Colors.white.withOpacity(0.5),
                                          thumbColor: Colors.white,
                                          barHeight: 4.0,
                                          thumbRadius: 7.0,
                                          timeLabelLocation: am.minimizedNotifier.value ? TimeLabelLocation.sides : TimeLabelLocation.below,
                                          timeLabelTextStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: height * 0.0175,
                                            fontFamily: 'Bahnschrift',
                                            fontWeight: FontWeight.normal,
                                          ),
                                          onSeek: (duration) {
                                            AudioPlayerController.audioPlayer.seek(duration);
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }
                            ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: minimizedVal ? width * 0.35 : width * 0.9,
                            height: height * 0.07,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if(!minimizedVal)
                                  ValueListenableBuilder(
                                      valueListenable: SettingsController.shuffleNotifier,
                                      builder: (context, value, child){
                                        return IconButton(
                                            onPressed: () {
                                              SettingsController.shuffle = !SettingsController.shuffle;
                                            },
                                            icon: Icon(
                                                value == false ? FluentIcons.shuffleOff : FluentIcons.shuffleOn,
                                                size: height * 0.025,
                                                color: Colors.white,
                                            ),
                                        );
                                      }
                                  ),

                                IconButton(
                                  onPressed: () async {
                                    await audioHandler.skipToPrevious();
                                  },
                                  icon: Icon(
                                    FluentIcons.previous,
                                    color: Colors.white,
                                    size: height * 0.022,
                                  ),
                                ),
                                MultiValueListenableBuilder(
                                    valueListenables: [SettingsController.playingNotifier],
                                    builder: (context, value, child){
                                      return IconButton(
                                        onPressed: () async {
                                          //print("pressed pause play");
                                          if (SettingsController.playing) {
                                            await audioHandler.pause();
                                          } else {
                                            await audioHandler.play();
                                          }
                                        },
                                        icon: Icon(
                                          SettingsController.playing ?
                                          FluentIcons.pause :
                                          FluentIcons.play,
                                          color: Colors.white,
                                          size: height * 0.025,
                                        ),
                                      );
                                    }
                                ),
                                IconButton(
                                  onPressed: () async {
                                    print("next");
                                    return await audioHandler.skipToNext();
                                  },
                                  icon: Icon(
                                    FluentIcons.next,
                                    color: Colors.white,
                                    size: height * 0.025,
                                  ),
                                ),
                                if (!minimizedVal)
                                ValueListenableBuilder(
                                    valueListenable: SettingsController.repeatNotifier,
                                    builder: (context, value, child){
                                      return IconButton(
                                        onPressed: () {
                                          SettingsController.repeat = !SettingsController.repeat;
                                        },
                                        icon:
                                        Icon(
                                            value == false ? FluentIcons.repeatOff: FluentIcons.repeatOn,
                                            size: height * 0.025,
                                            color: Colors.white,
                                        ),
                                      );
                                    }
                                ),


                              ],
                            ),
                          ),
                          if (!minimizedVal)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: height * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _pageController.animateToPage(0,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn
                                          );
                                        },
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          currentPage == 0 ? Icons.view_list_rounded : Icons.view_list_outlined,
                                          size: width * 0.05,
                                        )
                                    ),
                                    Container(
                                      width: 1,
                                      height: height * 0.025,
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _pageController.animateToPage(1,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn
                                          );
                                        },
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          currentPage == 1  ? Icons.photo_size_select_actual_rounded : Icons.photo_size_select_actual_outlined,
                                          size: width * 0.05,
                                        )
                                    ),
                                    Container(
                                      width: 1,
                                      height: height * 0.025,
                                      color: Colors.white,
                                    ),
                                    IconButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (){
                                          _pageController.animateToPage(2,
                                              duration: const Duration(milliseconds: 500),
                                              curve: Curves.easeIn
                                          );
                                        }, icon: Icon(
                                      currentPage == 2 ? Icons.lyrics_rounded : Icons.lyrics_outlined,
                                      size: width * 0.05,
                                    )
                                    ),
                                  ],
                                ),
                              ],
                            ),

                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );

              }
          );
        }
    );

  }
}
