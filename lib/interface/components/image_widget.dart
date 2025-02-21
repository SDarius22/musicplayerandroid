import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ImageWidget extends StatelessWidget {
  final int? id;
  final String? url;
  final String? path;
  final String? heroTag;
  final Widget? child;
  ImageWidget({super.key, this.id, this.child, this.heroTag, this.url, this.path,})
      : assert(path == null || id == null || url == null, "Cannot provide both!");

  final Image image = Image.asset('assets/logo.png', fit: BoxFit.cover,);
  late LocalDataProvider localData;

  @override
  Widget build(BuildContext context) {
    localData = Provider.of<LocalDataProvider>(context);
    if(id != null){
      return FutureBuilder(
        future: localData.getImage(id ?? -1),
        builder: (context, snapshot) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: snapshot.hasData?
            heroTag != null?
            Hero(
              tag: heroTag.toString(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.memory(snapshot.data!).image,
                    )
                ),
                child: child,
              ),
            ) :
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.memory(snapshot.data!).image,
                  )
              ),
              child: child,
            ) :
            snapshot.hasError?
            Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                )
            ):
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
    if(path != null){
      return FutureBuilder(
        future: Future(() async {
          var newPath = path?.split('/').last ?? "";
          var songs = await localData.audioQuery.queryWithFilters(
            newPath, WithFiltersType.AUDIOS,
            args: AudiosArgs.DISPLAY_NAME,
          );
          var song = SongModel(songs[0]);
          return await localData.getImage(song.id);
        }),
        builder: (context, snapshot) {
          return AspectRatio(
            aspectRatio: 1.0,
            child: snapshot.hasData?
            heroTag != null?
            Hero(
              tag: heroTag.toString(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.memory(snapshot.data!).image,
                    )
                ),
                child: child,
              ),
            ) :
            Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.memory(snapshot.data!).image,
                  )
              ),
              child: child,
            ) :
            snapshot.hasError?
            Center(
                child: Text(
                  '${snapshot.error} occurred',
                  style: const TextStyle(fontSize: 18),
                )
            ):
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
      child: heroTag != null?
      Hero(
        tag: heroTag.toString(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(url ?? "").image,
              )
          ),
          child: child,
        ),
      ) :
      Container(
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.network(url ?? "").image,
            )
        ),
        child: child,
      ),
    );
  }
}