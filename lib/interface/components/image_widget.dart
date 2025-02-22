import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ImageWidget extends StatelessWidget {
  final int? id;
  final String? url;
  final String? path;
  final String heroTag;
  final Widget? child;
  ImageWidget({super.key, this.id, this.child, required this.heroTag, this.url, this.path,})
      : assert(path == null || id == null || url == null, "Cannot provide both!");

  final ImageProvider image = Image.asset('assets/logo.png', fit: BoxFit.cover,).image;

  Widget buildImageWidget(ImageProvider image) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Hero(
        tag: heroTag.toString(),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: image,
              )
          ),
          child: child,
        ),
      ),
    );
  }

  Future getImage() {
    if(id != null){
      return Future(() async {
        var bytes = await LocalDataProvider().getImage(id ?? -1);
        return Image.memory(bytes).image;
      });
    }
    if(path != null){
      return Future(() async {
        var newPath = path?.split('/').last ?? "";
        var songs = await LocalDataProvider().audioQuery.queryWithFilters(
          newPath, WithFiltersType.AUDIOS,
          args: AudiosArgs.DISPLAY_NAME,
        );
        var song = SongModel(songs[0]);
        var bytes = await LocalDataProvider().getImage(song.id);
        return Image.memory(bytes).image;
      });
    }
    return Future(() async {
      return Image.network(url ?? "").image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getImage(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return buildImageWidget(snapshot.data ?? image);
        }
        return buildImageWidget(image);
      },
    );
  }
}