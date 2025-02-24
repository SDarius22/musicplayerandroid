import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class GridTile extends StatelessWidget {
  GridTile({super.key, required this.id, required this.type, this.selectedOverlay, this.onTap, this.onLongPress, this.unselectedOverlay,});
  final int id;
  final ArtworkType type;
  final Widget? unselectedOverlay;
  final Widget? selectedOverlay;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  final ImageProvider image = Image.asset('assets/logo.png', fit: BoxFit.cover,).image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: FutureBuilder(
          future: LocalDataProvider().audioQuery.queryArtwork(id, type, format: ArtworkFormat.JPEG, size: 512),
          builder: (context, snapshot){
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: snapshot.hasData
                      ? Image.memory(snapshot.data as Uint8List).image
                      : image,
                ),
              ),
              child: Consumer<SelectionProvider>(
                builder: (_, selectionProvider, __){
                  return selectionProvider.contains(id)
                      ? selectedOverlay ?? Container()
                      : unselectedOverlay ?? Container();
                },
              ),


            );
          },
        ),
      ),
    );

  }
}