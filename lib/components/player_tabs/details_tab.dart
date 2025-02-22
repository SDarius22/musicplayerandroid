import 'package:flutter/material.dart';
import 'package:musicplayerandroid/providers/info_provider.dart';
import 'package:musicplayerandroid/providers/local_data_provider.dart';
import 'package:musicplayerandroid/utils/text_scroll/text_scroll.dart';
import 'package:provider/provider.dart';

class DetailsTab extends StatelessWidget {
  DetailsTab({super.key});
  final ScrollController itemScrollController = ScrollController();
  late final InfoProvider infoProvider;
  late final LocalDataProvider localDataProvider;

  @override
  Widget build(BuildContext context) {
    try {
      infoProvider = Provider.of<InfoProvider>(context, listen: true);
      localDataProvider = Provider.of<LocalDataProvider>(context);
    } catch (e) {
      debugPrint("Error: $e");
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var boldSize = height * 0.018;
    var normalSize = height * 0.015;

   return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
     children: [
       AspectRatio(
         aspectRatio: 1.0,
         child: Container(
           decoration: BoxDecoration(
               color: Colors.black,
               borderRadius: BorderRadius.circular(width * 0.025),
               image: DecorationImage(
                 fit: BoxFit.cover,
                 image: Image.memory(infoProvider.currentSongImage).image,
               )
           ),
         ),
       ),
       TextScroll(
         infoProvider.currentSongModel.title.toString(),
         mode: TextScrollMode.endless,
         velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
         style: TextStyle(
           color: Colors.white,
           fontSize: boldSize,
           fontWeight: FontWeight.bold,
         ),
         delayBefore: const Duration(seconds: 2),
         pauseBetween: const Duration(seconds: 2),
       ),
       TextScroll(
         infoProvider.currentSongModel.artist ?? "Unknown",
         mode: TextScrollMode.bouncing,
         pauseOnBounce: const Duration(seconds: 1),
         style: TextStyle(
           color: Colors.white,
           fontSize: normalSize,
           fontWeight: FontWeight.normal,
         ),
         delayBefore: const Duration(seconds: 1),
         pauseBetween: const Duration(seconds: 1),
       ),
     ],
   );
  }
}