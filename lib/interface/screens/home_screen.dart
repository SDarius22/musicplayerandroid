// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:musicplayerandroid/interface/screens/settings_screen.dart';
// import '../../providers/app_manager.dart';
// import '../../providers/local_data_provider.dart';
// import '../../providers/netword_data_provider.dart';
// import '../../providers/settings_provider.dart';
// import '../../utils/fluenticons/fluenticons.dart';
// import '../widgets/song_player_widget.dart';
// import 'add_screen.dart';
// import 'albums_screen.dart';
// import 'artists_screen.dart';
// import 'download_screen.dart';
// import 'tracks_screen.dart';
// import 'playlists_screen.dart';
//
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>{
//   bool volume = true;
//
//   int currentPage = 3;
//   String userMessage = "No message";
//   final PageController _pageController = PageController(initialPage: 5);
//
//   late Future<void> _init;
//
//   @override
//   void initState() {
//     super.initState();
//     _init = Future(() async {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final am = AppManager();
//     final oc = NetworkDataProvider();
//
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     var boldSize = height * 0.0175;
//     var normalSize = height * 0.015;
//     //var smallSize = height * 0.0125;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Music Player",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: boldSize,
//           ),
//         ),
//         actions: [
//           ValueListenableBuilder(
//             valueListenable: LocalDataProvider.selectedPaths,
//             builder: (context, value, child) {
//               return value.isNotEmpty ?
//               IconButton(
//                 icon: const Icon(
//                   FluentIcons.addAll,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   List<String> value = LocalDataProvider.selectedPaths.value;
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => AddScreen(paths: value)
//                       )
//                   );
//                 },
//
//               )
//               : const SizedBox();
//
//             },
//           ),
//
//           IconButton(
//             icon: const Icon(
//               FluentIcons.settings,
//               color: Colors.white,
//             ),
//             onPressed: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SettingsScreen()),
//               );
//             },
//           ),
//           ValueListenableBuilder(
//             valueListenable: oc.loggedInNotifier,
//             builder: (context, value, child) =>
//                 IconButton(
//                   onPressed: () async {
//                     print("Tapped user");
//                     am.minimizedNotifier.value = true;
//                     // am.navigatorKey.currentState!.push(
//                     //     MaterialPageRoute(
//                     //         builder: (BuildContext context) {
//                     //           return const UserScreen();
//                     //         }));
//                   },
//                   icon: Icon(
//                     value ? FluentIcons.circlePersonFilled : FluentIcons.circlePerson,
//                     color: Colors.white,
//                   ),
//                 ),
//           ),
//         ],
//       ),
//       body: SizedBox(
//         width: width,
//         height: height,
//         child: Stack(
//           children: [
//             FutureBuilder(
//               future: _init,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done){
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                               child: Container(
//                                   height: height * 0.05,
//                                   color: currentPage != 0 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                       onTap: (){
//                                         //print("Artists");
//                                         _pageController.animateToPage(0,
//                                             duration: const Duration(milliseconds: 500),
//                                             curve: Curves.easeIn
//                                         );
//                                       },
//                                       child: Text(
//                                         "Artists",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: currentPage != 0 ? normalSize : boldSize,
//                                         ),
//                                       )
//                                   )
//                               )
//                           ),
//                           Expanded(
//                               child: Container(
//                                   height: height * 0.05,
//                                   color: currentPage != 1 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                       onTap: (){
//                                         //print("Artists");
//                                         _pageController.animateToPage(1,
//                                             duration: const Duration(milliseconds: 500),
//                                             curve: Curves.easeIn
//                                         );
//                                       },
//                                       child: Text(
//                                         "Albums",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: currentPage != 1 ? normalSize : boldSize,
//                                         ),
//                                       )
//                                   )
//                               )
//                           ),
//                           Expanded(
//                               child: Container(
//                                   height: height * 0.05,
//                                   color: currentPage != 2 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                       onTap: (){
//                                         //print("Artists");
//                                         _pageController.animateToPage(2,
//                                             duration: const Duration(milliseconds: 500),
//                                             curve: Curves.easeIn
//                                         );
//                                       },
//                                       child: Text(
//                                         "Download",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: currentPage != 2 ? normalSize : boldSize,
//                                         ),
//                                       )
//                                   )
//                               )
//                           ),
//                           Expanded(
//                               child: Container(
//                                   height: height * 0.05,
//                                   color: currentPage != 3 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                       onTap: (){
//                                         //print("Artists");
//                                         _pageController.animateToPage(3,
//                                             duration: const Duration(milliseconds: 500),
//                                             curve: Curves.easeIn
//                                         );
//                                       },
//                                       child: Text(
//                                         "Playlists",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: currentPage != 3 ? normalSize : boldSize,
//                                         ),
//                                       )
//                                   )
//                               )
//                           ),
//                           Expanded(
//                               child: Container(
//                                   height: height * 0.05,
//                                   color: currentPage != 4 ? const Color(0xFF0E0E0E) : const Color(0xFF1b1b1b),
//                                   alignment: Alignment.center,
//                                   child: GestureDetector(
//                                       onTap: (){
//                                         //print("Artists");
//                                         _pageController.animateToPage(4,
//                                             duration: const Duration(milliseconds: 500),
//                                             curve: Curves.easeIn
//                                         );
//                                       },
//                                       child: Text(
//                                         "Tracks",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: currentPage != 4 ? normalSize : boldSize,
//                                         ),
//                                       )
//                                   )
//                               )
//                           ),
//                         ],
//                       ),
//                       Expanded(
//                         child: PageView(
//                           onPageChanged: (int index){
//                             setState(() {
//                               currentPage = index;
//                             });
//                           },
//                           controller: _pageController,
//                           scrollDirection: Axis.horizontal,
//                           scrollBehavior: ScrollConfiguration.of(context).copyWith(
//                             dragDevices: {
//                               PointerDeviceKind.touch,
//                               PointerDeviceKind.mouse,
//                             },
//                           ),
//                           physics: const AlwaysScrollableScrollPhysics(),
//                           children: const [
//                             Artists(),
//                             Albums(),
//                             Download(),
//                             Playlists(),
//                             Tracks(),
//                           ],
//
//                         ),
//                       ),
//
//                     ],
//                   );
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 500),
//               alignment: Alignment.bottomCenter,
//               child: const SongPlayerWidget(),
//             ),
//           ],
//         )
//       ),
//     );
//   }
// }
//
//
