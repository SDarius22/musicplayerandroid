import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicplayerandroid/providers/audio_provider.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';
import 'package:musicplayerandroid/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/fluenticons/fluenticons.dart';

class SettingsScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const SettingsScreen(),
    );
  }
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String dropDownValue = "Off";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var boldSize = height * 0.0175;
    var normalSize = height * 0.015;
    var smallSize = height * 0.0125;
    return Consumer<SettingsProvider>(
      builder: (_, settingsProvider, __){
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: boldSize,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(FluentIcons.menu),
                onPressed: () {
                  Scaffold.of(PageProvider().navigatorKey.currentContext!).openEndDrawer();
                },
              ),
            ],
          ),
          body: SizedBox(
            width: width,
            height: height,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                child: ListView(
                  padding: EdgeInsets.only(
                    bottom: height * 0.05,
                    right: width * 0.01,
                  ),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Library Settings",
                          style: TextStyle(
                            fontSize: smallSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    ),

                    ListTile(
                      title: Text(
                        "Queue Add Order",
                        style: TextStyle(
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "Choose where the tracks are added to the queue",
                        style: TextStyle(
                          fontSize: smallSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade50,
                        ),
                      ),
                      trailing: DropdownButton<String>(
                          value: settingsProvider.queueAdd,
                          icon: Icon(
                            FluentIcons.down,
                            color: Colors.white,
                            size: height * 0.02,
                          ),
                          style: TextStyle(
                            fontSize: normalSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          underline: Container(height: 0,),
                          borderRadius: BorderRadius.circular(width * 0.01),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          items: const [
                            DropdownMenuItem(
                              value: 'first',
                              child: Text("At the beginning"),
                            ),
                            DropdownMenuItem(
                              value: 'next',
                              child: Text("After Current"),
                            ),
                            DropdownMenuItem(
                              value: 'last',
                              child: Text("At the end"),
                            ),
                          ],
                          onChanged: (String? newValue){
                            settingsProvider.queueAdd = newValue ?? "last";
                          }
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Queue Play Order",
                        style: TextStyle(
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "Choose how you want playing a song to behave",
                        style: TextStyle(
                          fontSize: smallSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade50,
                        ),
                      ),
                      trailing: DropdownButton<String>(
                          value: settingsProvider.queuePlay,
                          icon: Icon(
                            FluentIcons.down,
                            color: Colors.white,
                            size: height * 0.02,
                          ),
                          style: TextStyle(
                            fontSize: normalSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                          underline: Container(height: 0,),
                          borderRadius: BorderRadius.circular(width * 0.01),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text("Play All Tracks"),
                            ),
                            DropdownMenuItem(
                              value: 'selected',
                              child: Text("Play Selected Track"),
                            ),
                          ],
                          onChanged: (String? newValue){
                            settingsProvider.queuePlay = newValue ?? "all";
                          }
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Playback Settings",
                          style: TextStyle(
                            fontSize: smallSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    ),
                    ///Playback Speed
                    ListTile(
                      title: Text(
                        "Playback Speed",
                        style: TextStyle(
                          fontSize: normalSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "Set the playback speed to a certain value",
                        style: TextStyle(
                          fontSize: smallSize,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade50,
                        ),
                      ),
                      trailing: Consumer<AudioProvider>(
                        builder: (_, audioProvider, __){
                          return SizedBox(
                            width: width * 0.4,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2,
                                thumbColor: Colors.white,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: height * 0.0075),
                                showValueIndicator: ShowValueIndicator.always,
                                activeTrackColor: audioProvider.lightColor,
                                inactiveTrackColor: Colors.white,
                                valueIndicatorColor: Colors.white,
                                valueIndicatorTextStyle: TextStyle(
                                  fontSize: smallSize,
                                  color: Colors.black,
                                ),
                                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                              ),
                              child: Slider(
                                min: 0.0,
                                max: 2.0,
                                divisions: 10,
                                label: "${audioProvider.audioPlayer.speed.toStringAsPrecision(2)}x",
                                mouseCursor: SystemMouseCursors.click,
                                value: audioProvider.audioPlayer.speed,
                                onChanged: (double value) {
                                  audioProvider.setSpeed(value);
                                },
                              ),
                            ),
                          );
                        }
                      ),
                    ),

                    //TODO: recode everything below

                    // ///Timer
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Timer",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Set a timer to stop playback after a certain amount of time", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     ValueListenableBuilder(
                    //         valueListenable: SettingsProvider.sleepTimerNotifier,
                    //         builder: (context, value, child){
                    //           String timer = value == 0 ? "Off" : value == 1 ? "1 minute" : value == 15 ? "15 minutes" : value == 30 ? "30 minutes" : value == 45 ? "45 minutes" : value == 60 ? "1 hour" : value == 120 ? "2 hours" : value == 180 ? "3 hours" : "4 hours";
                    //           return DropdownButton<String>(
                    //               value: timer,
                    //               icon: Icon(
                    //                 FluentIcons.down,
                    //                 color: Colors.white,
                    //                 size: height * 0.025,
                    //               ),
                    //               style: TextStyle(
                    //                 fontSize: normalSize,
                    //                 fontWeight: FontWeight.normal,
                    //                 color: Colors.white,
                    //               ),
                    //               underline: Container(
                    //                 height: 0,
                    //               ),
                    //               borderRadius: BorderRadius.circular(width * 0.01),
                    //               padding: EdgeInsets.zero,
                    //               alignment: Alignment.center,
                    //               items: const [
                    //                 DropdownMenuItem(
                    //                   value: 'Off',
                    //                   child: Text("Off"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '1 minute',
                    //                   child: Text("1 minute"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '15 minutes',
                    //                   child: Text("15 minutes"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '30 minutes',
                    //                   child: Text("30 minutes"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '45 minutes',
                    //                   child: Text("45 minutes"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '1 hour',
                    //                   child: Text("1 hour"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '2 hours',
                    //                   child: Text("2 hours"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '3 hours',
                    //                   child: Text("3 hours"),
                    //                 ),
                    //                 DropdownMenuItem(
                    //                   value: '4 hours',
                    //                   child: Text("4 hours"),
                    //                 ),
                    //               ],
                    //               onChanged: (String? newValue){
                    //                 final apc = AudioProvider();
                    //                 apc.setTimer(newValue ?? "Off");
                    //               }
                    //           );
                    //         }
                    //     ),
                    //
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.025,
                    // ),
                    //
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Application Settings",
                    //       style: TextStyle(
                    //         fontSize: smallSize,
                    //         fontWeight: FontWeight.normal,
                    //         color: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: height * 0.01,
                    //     ),
                    //     Container(
                    //       height: 1,
                    //       color: Colors.grey.shade400,
                    //     ),
                    //     SizedBox(
                    //       height: height * 0.01,
                    //     ),
                    //   ],
                    // ),
                    //
                    // ///In-App Notifications
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "In-App Notifications",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Show notifications in the app", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     Switch(
                    //       value: SettingsProvider.appNotifications,
                    //       onChanged: (value){
                    //         setState(() {
                    //           SettingsProvider.appNotifications = value;
                    //         });
                    //       },
                    //       trackColor: WidgetStateProperty.all(SettingsProvider.lightColorNotifier.value),
                    //       thumbColor: WidgetStateProperty.all(Colors.white),
                    //       thumbIcon: WidgetStateProperty.all(SettingsProvider.appNotifications ? const Icon(Icons.check, color: Colors.black,) : const Icon(Icons.close, color: Colors.black,)),
                    //       activeColor: Colors.white,
                    //     ),
                    //
                    //
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    //
                    // ///Deezer ARL
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Deezer ARL",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Your Deezer ARL token", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     SizedBox(
                    //       width: width * 0.3,
                    //       child: TextField(
                    //         controller: TextEditingController(text: SettingsProvider.deezerARL),
                    //         onChanged: (value){
                    //           SettingsProvider.deezerARL = value;
                    //         },
                    //         style: TextStyle(
                    //           fontSize: normalSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.white,
                    //         ),
                    //         decoration: InputDecoration(
                    //           isDense: true,
                    //           hintText: "Deezer ARL",
                    //           hintStyle: TextStyle(
                    //             color: Colors.grey.shade50,
                    //           ),
                    //           enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(width * 0.01),
                    //             borderSide: const BorderSide(
                    //               color: Colors.grey,
                    //             ),
                    //           ),
                    //           focusedBorder: const OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    //
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Playlist Settings",
                    //       style: TextStyle(
                    //         fontSize: smallSize,
                    //         fontWeight: FontWeight.normal,
                    //         color: Colors.grey.shade400,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: height * 0.01,
                    //     ),
                    //     Container(
                    //       height: 1,
                    //       color: Colors.grey.shade400,
                    //     ),
                    //     SizedBox(
                    //       height: height * 0.01,
                    //     ),
                    //   ],
                    // ),
                    //
                    // ///Import Playlists
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Import Playlist",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Import a playlist from your library", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     IconButton(
                    //         onPressed: () async {
                    //           FilePickerResult? result = await FilePicker.platform.pickFiles(initialDirectory: SettingsProvider.directory, type: FileType.custom, allowedExtensions: ['m3u'], allowMultiple: false);
                    //           if(result != null) {
                    //             File file = File(result.files.single.path ?? "");
                    //             List<String> lines = file.readAsLinesSync();
                    //             String playlistName = file.path.split("/").last.split(".").first;
                    //             lines.removeAt(0);
                    //             for (int i = 0; i < lines.length; i++) {
                    //               lines[i] = lines[i].split("/").last;
                    //             }
                    //             Navigator.push(context, MaterialPageRoute(builder: (context) => CreateScreen(name: playlistName, paths: lines,)));
                    //           }
                    //
                    //         },
                    //         icon: Icon(FluentIcons.open, color: Colors.white, size: height * 0.03,)
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),
                    //
                    // ///Export Playlists
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Export Playlists",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Export playlists to your library", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     IconButton(
                    //         onPressed: (){
                    //           Navigator.push(context, MaterialPageRoute(builder: (context) => const ExportScreen()));
                    //         },
                    //         icon: Icon(FluentIcons.open, color: Colors.white, size: height * 0.03,)
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.02,
                    // ),

                    ///Possible more settings:
                    ///Crossfade between songs -> not sure if this is possible
                    ///Theme settings - maybe in the future
                    // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Theme Settings",
                    //           style: TextStyle(
                    //             fontSize: normalSize,
                    //             fontWeight: FontWeight.normal,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: height * 0.005,
                    //         ),
                    //         Text("Choose between light and dark theme", style: TextStyle(
                    //           fontSize: smallSize,
                    //           fontWeight: FontWeight.normal,
                    //           color: Colors.grey.shade50,
                    //         ),),
                    //       ],
                    //     ),
                    //     const Spacer(),
                    //     Switch(
                    //       value: widget.controller.settings.theme,
                    //       onChanged: (value){
                    //         setState(() {
                    //           widget.controller.settings.theme = value;
                    //           widget.controller.themeNotifier.value = value;
                    //         });
                    //
                    //         widget.controller.settingsBox.put(widget.controller.settings);
                    //       },
                    //       trackColor: WidgetStateProperty.all(widget.controller.colorNotifier2.value),
                    //       thumbColor: WidgetStateProperty.all(Colors.white),
                    //       thumbIcon: WidgetStateProperty.all(widget.controller.settings.theme ? const Icon(Icons.sunny, color: Colors.black,) : const Icon(Icons.nightlight, color: Colors.black,)),
                    //       activeColor: Colors.white,
                    //     ),
                    //
                    //
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: height * 0.01,
                    // ),
                    // Container(
                    //   height: 1,
                    //   color: Colors.grey.shade600,
                    // ),
                    // SizedBox(
                    //   height: height * 0.01,
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}