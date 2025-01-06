import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controller/worker_controller.dart';

class ImageWidget extends StatefulWidget {
  final int? id;
  final String? url;
  final String? path;
  final String? heroTag;
  final Widget? buttons;
  const ImageWidget({super.key, this.id, this.buttons, this.heroTag, this.url, this.path})
      : assert(path == null || id == null || url == null, "Cannot provide both!")
  ;

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  ValueNotifier<bool> isHovered = ValueNotifier(false);
  Image image = Image.asset('assets/bg.png', fit: BoxFit.cover,);

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(widget.id != null){
      return FutureBuilder(
        future: WorkerController.getImage(widget.id ?? -1),
        builder: (context, snapshot) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: snapshot.hasData?
            MouseRegion(
              onEnter: (event) {
                isHovered.value = true;
              },
              onExit: (event) {
                isHovered.value = false;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if(widget.heroTag != null)
                    Hero(
                      tag: widget.heroTag.toString(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.memory(snapshot.data!).image,
                            )
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.memory(snapshot.data!).image,
                          )
                      ),
                    ),
                  if(widget.buttons != null)
                    ValueListenableBuilder(
                      valueListenable: isHovered,
                      builder: (context, value, child) {
                        return value?
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              alignment: Alignment.center,
                              child: widget.buttons,
                            ),
                          ),
                        ) :
                        Container();
                      },
                    ),
                ],
              ),
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
                    image: image.image,
                  )
              ),
            ),
          );
        },
      );
    }
    if(widget.path != null){
      return FutureBuilder(
        future: Future(() async {
          var path = widget.path?.split('/').last ?? "";
          var songs = await WorkerController.audioQuery.queryWithFilters(
            path, WithFiltersType.AUDIOS,
            args: AudiosArgs.DISPLAY_NAME,
          );
          var song = SongModel(songs[0]);
          return await WorkerController.getImage(song.id);
        }),
        builder: (context, snapshot) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: snapshot.hasData?
            MouseRegion(
              onEnter: (event) {
                isHovered.value = true;
              },
              onExit: (event) {
                isHovered.value = false;
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if(widget.heroTag != null)
                    Hero(
                      tag: widget.heroTag.toString(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.memory(snapshot.data!).image,
                            )
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.memory(snapshot.data!).image,
                          )
                      ),
                    ),
                  if(widget.buttons != null)
                    ValueListenableBuilder(
                      valueListenable: isHovered,
                      builder: (context, value, child) {
                        return value?
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              alignment: Alignment.center,
                              child: widget.buttons,
                            ),
                          ),
                        ) :
                        Container();
                      },
                    ),
                ],
              ),
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
                    image: image.image,
                  )
              ),
            ),
          );
        },
      );
    }
    return AspectRatio(
      aspectRatio: 1.0,
      child: MouseRegion(
        onEnter: (event) {
          isHovered.value = true;
        },
        onExit: (event) {
          isHovered.value = false;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.network(widget.url ?? "").image,
                  )
              ),
            ),
            if(widget.buttons != null)
              ValueListenableBuilder(
                valueListenable: isHovered,
                builder: (context, value, child) {
                  return value?
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        alignment: Alignment.center,
                        child: widget.buttons,
                      ),
                    ),
                  ) :
                  Container();
                },
              ),
          ],
        ),
      ),
    );

  }
}
