// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:deezer/deezer.dart';
// import 'package:on_audio_query/on_audio_query.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
//
// import '../domain/playlist_type.dart';
// import '../domain/settings_type.dart';
// import '../repository/objectbox.g.dart';
// import '../utils/dominant_color/dominant_color.dart';
// import '../repository/objectBox.dart';
//
//
//
// class Controller{
//   AudioPlayer audioPlayer = AudioPlayer();
//
//   bool firstTimeRetrieving = true;
//
//   final navigatorKey = GlobalKey<NavigatorState>();
//
//   final secretKey = encrypt.Key.fromUtf8("eP9CLbcaUxKfvhhFLWcusXWo3ZS2nR1P");
//   final iv = encrypt.IV.fromUtf8("1234567890123456");
//
//   Box<PlaylistType> playlistBox = ObjectBox.store.box<PlaylistType>();
//   Box<Settings> settingsBox = ObjectBox.store.box<Settings>();
//   late Deezer instance;
//
//   List<String> controllerQueue = []; // this is the queue, this can be shuffled
//   OnAudioQuery audioQuery = OnAudioQuery();
//   Settings settings = Settings();
//
//   ValueNotifier<bool> downloadNotifier = ValueNotifier<bool>(false);
//   ValueNotifier<bool> finishedRetrievingNotifier = ValueNotifier<bool>(false);
//
//   ValueNotifier<bool> playingNotifier = ValueNotifier<bool>(false);
//   ValueNotifier<bool> repeatNotifier = ValueNotifier<bool>(false);
//   ValueNotifier<bool> searchNotifier = ValueNotifier<bool>(false);
//   ValueNotifier<bool> shuffleNotifier = ValueNotifier<bool>(false);
//
//   ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.white); // Light color, for lyrics and sliders
//   ValueNotifier<Color> colorNotifier2 = ValueNotifier<Color>(Colors.black); // Dark color, for background of player and window bar
//
//   ValueNotifier<double> balanceNotifier = ValueNotifier<double>(0);
//   ValueNotifier<double> speedNotifier = ValueNotifier<double>(1);
//   ValueNotifier<double> volumeNotifier = ValueNotifier<double>(0.5);
//
//   ValueNotifier<int> indexNotifier = ValueNotifier<int>(0); // index of the song in the queue that can be shuffled
//   ValueNotifier<int> sleepTimerNotifier = ValueNotifier<int>(0);
//   ValueNotifier<int> sliderNotifier = ValueNotifier<int>(0);
//
//   ValueNotifier<String> notification = ValueNotifier<String>('');
//   ValueNotifier<String> timerNotifier = ValueNotifier<String>('Off');
//
//
//   /// Constructor for the Controller class
//   Controller() {
//     settings = settingsBox.getAll().last;
//     // settingsBox = ObjectBox.store.box<Settings>();
//     // if (settingsBox.isEmpty()) {
//     //   print("Initialising settings");
//     //   settingsBox.put(settings);
//     // }
//     // else {
//     //   settings = settingsBox.getAll().last;
//     //   // for (Settings setting in settingsBox.getAll()){
//     //   //   print(setting.playingSongsUnShuffled.first.title);
//     //   // }
//     // }
//     if(settings.deezerARL.isNotEmpty){
//       initDeezer();
//     }
//
//     playlistBox = ObjectBox.store.box<PlaylistType>();
//     audioPlayer.onPositionChanged.listen((Duration event){
//       sliderNotifier.value = event.inMilliseconds;
//     });
//
//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       playingNotifier.value = state == PlayerState.playing;
//       if(state == PlayerState.completed){
//         if(repeatNotifier.value){
//           print("repeat");
//           sliderNotifier.value = 0;
//           playSong();
//         }
//         else {
//           print("next");
//           nextSong();
//         }
//       }
//     });
//
//     controllerQueue.addAll(settings.queue);
//     if (controllerQueue.isNotEmpty) {
//       indexChange(controllerQueue[settings.index]);
//       //playSong();
//     }
//     // if (args.isNotEmpty) {
//     //   print(args);
//     //   List<String> songs = args.where((element) => element.endsWith(".mp3") || element.endsWith(".flac") || element.endsWith(".wav") || element.endsWith(".m4a")).toList();
//     //   updatePlaying(songs, 0);
//     //   indexChange(controllerQueue[0]);
//     //   playSong();
//     // }
//     // else{
//     //   if(controllerQueue.isNotEmpty){
//     //     indexChange(controllerQueue[settings.index]);
//     //     //playSong();
//     //   }
//     // }
//
//   }
//
//   Future<void> addToPlaylist(PlaylistType playlist, List<SongModel> songs) async {
//     if(playlist.nextAdded == 'last'){
//       for(var song in songs){
//         if (playlist.songs.contains(song.data)){
//           continue;
//         }
//         playlist.songs.add(song.data);
//       }
//       playlistBox.put(playlist);
//     }
//     else{
//       for(int i = songs.length - 1; i >= 0; i--){
//         if (playlist.songs.contains(songs[i].data)){
//           continue;
//         }
//         playlist.songs.insert(0, songs[i].data);
//       }
//       playlistBox.put(playlist);
//     }
//     exportPlaylist(playlist);
//
//   }
//
//   Future<void> addToQueue(List<String> songs) async {
//     print("Adding to queue ${songs.length} songs.");
//     //loadingNotifier.value = true;
//     if (settings.queueAdd == 'last') {
//       //print("last");
//       controllerQueue.addAll(songs);
//       settings.queue.addAll(songs);
//       //print(settings.queue);
//       settingsBox.put(settings);
//     }
//     else if (settings.queueAdd == 'next') {
//       //print("next");
//       controllerQueue.insertAll(indexNotifier.value + 1, songs);
//       settings.queue.insertAll(indexNotifier.value + 1, songs);
//       settingsBox.put(settings);
//     }
//     else if (settings.queueAdd == 'first') {
//       //print("first");
//       controllerQueue.insertAll(0, songs);
//       settings.queue.insertAll(0, songs);
//       settingsBox.put(settings);
//     }
//     shuffleSongs();
//     //loadingNotifier.value = false;
//   }
//
//   Future<void> createPlaylist(PlaylistType playlist) async {
//     playlistBox.put(playlist);
//     exportPlaylist(playlist);
//   }
//
//   Future<void> deletePlaylist(PlaylistType playlist) async {
//     playlistBox.remove(playlist.id);
//     try {
//       var file = File("${settings.directory}/${playlist.name}.m3u");
//       file.delete();
//       showNotification("Playlist ${playlist.name} deleted.", 3500);
//     }
//     catch(e){
//       print(e);
//       showNotification("Playlist ${playlist.name} deleted.", 3500);
//     }
//   }
//
//   Future<void> exportPlaylist(PlaylistType playlist) async {
//     var file = File("${settings.directory}/${playlist.name}.m3u");
//     file.writeAsStringSync("#EXTM3U\n");
//     for (var song in playlist.songs){
//       file.writeAsStringSync('$song\n', mode: FileMode.append);
//     }
//   }
//
//   Future<List<AlbumModel>> getAlbums(String query) async {
//     List<AlbumModel> albums = await audioQuery.queryAlbums();
//     List<AlbumModel> searchResults = [];
//     for (var album in albums){
//       if(album.album.toLowerCase().contains(query.toLowerCase())){
//         searchResults.add(album);
//       }
//     }
//     return searchResults;
//   }
//
//   Future<List<ArtistModel>> getArtists(String query) async {
//     List<ArtistModel> artists = await audioQuery.queryArtists();
//     List<ArtistModel> searchResults = [];
//     for (var artist in artists){
//       if(artist.artist.toLowerCase().contains(query.toLowerCase())){
//         searchResults.add(artist);
//       }
//     }
//     return searchResults;
//   }
//
//   Future<Duration> getDuration(SongModel song) async {
//     try{
//       if(song.duration != null && song.duration != 0){
//         return Duration(milliseconds: song.duration!);
//       }
//       else{
//         Duration songDuration = await audioPlayer.getDuration() ?? Duration.zero;
//         return songDuration;
//       }
//     }
//     catch(e){
//       print(e);
//       return await audioPlayer.getDuration() ?? Duration.zero;
//     }
//   }
//
//   Future<Uint8List> getImage(String path) async{
//     ByteData data = await rootBundle.load('assets/bg.png');
//     Uint8List image =  data.buffer.asUint8List();
//     var song = await getSong(path);
//     image = await audioQuery.queryArtwork(song.id, ArtworkType.AUDIO, format: ArtworkFormat.JPEG, size: 512,) ?? image;
//
//     return image;
//   }
//
//   Future<List<String>> getLyrics(String path) async{
//     var lyricsPath = path.replaceRange(path.lastIndexOf("."), path.length, ".lrc");
//     if(!File(lyricsPath).existsSync()){
//       try {
//         return await searchLyrics();
//       }
//       catch(e){
//         print(e);
//         return ["No lyrics found", "No lyrics found"];
//       }
//     }
//     else{
//       return [File(lyricsPath).readAsStringSync(), File(lyricsPath).readAsStringSync()];
//     }
//   }
//
//   Future<List<PlaylistType>> getPlaylists(String searchValue) async {
//     return playlistBox.query(PlaylistType_.name.contains(searchValue, caseSensitive: false)).order(PlaylistType_.name).build().find();
//   }
//
//   Future<List<SongModel>> getQueue() async {
//     List<SongModel> queue = [];
//     var songs = await audioQuery.querySongs(
//       sortType: SongSortType.TITLE,
//     );
//
//     for (String path in controllerQueue){
//         queue.add(songs.firstWhere((element) => element.data == path));
//     }
//     return queue;
//   }
//
//   Future<SongModel> getSong(String path) async {
//     var songs = await audioQuery.queryWithFilters(
//       filters: [FilterSongPath(path)],
//     );
//     for (var song in songs){
//       if (song.data == path){
//         // var songUniqueString = "${song.title}//${song.artist}//${song.album}//${song.duration}//${song.data.split('/').last}//${song.track}";
//         // if(!settings.missingSongs.contains(songUniqueString)){
//         //   settings.missingSongs.add(songUniqueString);
//         //   settingsBox.put(settings);
//         // }
//         return song;
//       }
//     }
//     throw Exception("Song not found");
//   }
//
//   Future<List<SongModel>> getSongs(String enteredKeyword) async {
//     if (settings.queue.isEmpty){
//       print("empty");
//       var songs = await audioQuery.queryWithFilters(
//         enteredKeyword,
//         WithFiltersType.AUDIOS,
//       );
//
//       List<String> initialQueue = songs.map((e) => e.data).toList();
//       print(initialQueue.length);
//       controllerQueue.addAll(initialQueue);
//       settings.queue.addAll(initialQueue);
//     }
//     if(controllerQueue.isEmpty){
//       controllerQueue.addAll(settings.queue);
//       settings.index = 0;
//       indexNotifier.value = 0;
//       indexChange(controllerQueue[0]);
//     }
//
//     if(settings.firstTime){
//       settings.firstTime = false;
//     }
//     settingsBox.put(settings);
//     if(firstTimeRetrieving){
//       firstTimeRetrieving = false;
//       finishedRetrievingNotifier.value = true;
//     }
//     var songs = await audioQuery.querySongs();
//     List<SongModel> searchResults = [];
//     //int count = 0;
//     for (var song in songs){
//       var artist = song.artist ?? "Unknown artist";
//       var album = song.album ?? "Unknown album";
//       if(enteredKeyword.isEmpty || song.title.toLowerCase().contains(enteredKeyword.toLowerCase()) || artist.toLowerCase().contains(enteredKeyword.toLowerCase()) || album.toLowerCase().contains(enteredKeyword.toLowerCase())){
//         searchResults.add(song);
//         var songUniqueString = "${song.title}//${song.artist}//${song.album}//${song.duration}//${song.data.split('/').last}//${song.track}";
//         if(!settings.missingSongs.contains(songUniqueString)){
//           settings.missingSongs.add(songUniqueString);
//           settingsBox.put(settings);
//         }
//       }
//     }
//     return searchResults;
//   }
//
//   Future<void> indexChange(String song) async{
//     sliderNotifier.value = 0;
//     playingNotifier.value = false;
//     indexNotifier.value = controllerQueue.indexOf(song);
//     settings.index = settings.queue.indexOf(song);
//     settingsBox.put(settings);
//   }
//
//   Future<dynamic> initDeezer() async {
//     try{
//       instance = await Deezer.create(arl: settings.deezerARL);
//     }
//     catch(e){
//       print(e);
//     }
//   }
//
//   Future<void> nextSong() async {
//     int newIndex;
//     if (indexNotifier.value == controllerQueue.length - 1) {
//       newIndex = 0;
//     } else {
//       newIndex = indexNotifier.value + 1;
//     }
//     indexChange(controllerQueue[newIndex]);
//     playSong();
//   }
//
//   Future<void> playSong() async {
//
//     if (playingNotifier.value){
//       print("pause");
//       await audioPlayer.pause();
//       playingNotifier.value = false;
//     }
//     else{
//       print("resume");
//       var song = await getSong(controllerQueue[indexNotifier.value]);
//       await audioPlayer.play(DeviceFileSource(song.data), position: Duration(milliseconds: sliderNotifier.value));
//       playingNotifier.value = true;
//     }
//   }
//
//   Future<void> previousSong() async {
//     if(sliderNotifier.value > 5000){
//       audioPlayer.seek(const Duration(milliseconds: 0));
//     }
//     else {
//       int newIndex;
//       if (indexNotifier.value == 0) {
//         newIndex = controllerQueue.length - 1;
//       } else {
//         newIndex = indexNotifier.value - 1;
//       }
//       indexChange(controllerQueue[newIndex]);
//       playSong();
//     }
//   }
//
//   Future<void> removeFromQueue(String song) async {
//     if(controllerQueue.length == 1){
//       showNotification("The queue cannot be empty.", 3500);
//       print("The queue cannot be empty");
//       return;
//     }
//
//     String current = controllerQueue[indexNotifier.value];
//     controllerQueue.remove(song);
//     settings.queue.remove(song);
//     if(!settings.queue.contains(current)){
//       indexChange(controllerQueue[0]);
//       playSong();
//     }
//     else{
//       indexNotifier.value = controllerQueue.indexOf(current);
//       settings.index = settings.queue.indexOf(current);
//     }
//     settingsBox.put(settings);
//   }
//
//   Future<void> reorderQueue(int oldIndex, int newIndex) async {
//     if (oldIndex < newIndex) {
//       newIndex -= 1;
//     }
//     String song = settings.queue.removeAt(oldIndex);
//     settings.queue.insert(newIndex, song);
//     if (oldIndex == indexNotifier.value) {
//       settings.index = newIndex;
//     } else if (oldIndex < indexNotifier.value && newIndex >= indexNotifier.value) {
//       settings.index -= 1;
//     } else if (oldIndex > indexNotifier.value && newIndex <= indexNotifier.value) {
//       settings.index += 1;
//     }
//     settingsBox.put(settings);
//   }
//
//   void reset(){
//     finishedRetrievingNotifier.value = false;
//     playlistBox.removeAll();
//     controllerQueue.clear();
//     firstTimeRetrieving = true;
//   }
//
//   Future<dynamic> searchDeezer(String searchValue) async {
//     if(searchValue.isEmpty){
//       return [];
//     }
//     final Map<String, String> cookies = {'arl': settings.deezerARL};
//     String searchUrl = 'https://api.deezer.com/search?q=$searchValue&limit=56&index=0&output=json';
//     print(searchUrl);
//
//     final http.Response getResponse = await http.get(Uri.parse(searchUrl), headers: {
//       'Cookie': 'arl=${cookies['arl']}',
//     });
//
//     final Map<String, dynamic> getResponseJson = jsonDecode(getResponse.body);
//     return(getResponseJson['data']);
//   }
//
//   Future<List<SongModel>> searchLocal(String enteredKeyword) async {
//     var songs = await audioQuery.querySongs();
//     List<SongModel> searchResults = [];
//     //int count = 0;
//     for (var song in songs){
//       var artist = song.artist ?? "Unknown artist";
//       var album = song.album ?? "Unknown album";
//       if(song.title.toLowerCase().contains(enteredKeyword.toLowerCase()) || artist.toLowerCase().contains(enteredKeyword.toLowerCase()) || album.toLowerCase().contains(enteredKeyword.toLowerCase())){
//         searchResults.add(song);
//         //count++;
//       }
//       // if(count == 25){
//       //   break;
//       // }
//     }
//     return searchResults;
//   }
//
//   Future<List<String>> searchLyrics() async {
//     //plainLyricNotifier.value = 'Searching for lyrics...';
//     final Map<String, String> cookies = {'arl': settings.deezerARL};
//     final Map<String, String> params = {'jo': 'p', 'rto': 'c', 'i': 'c'};
//     const String loginUrl = 'https://auth.deezer.com/login/arl';
//     const String deezerApiUrl = 'https://pipe.deezer.com/api';
//     SongModel song = await getSong(controllerQueue[indexNotifier.value]);
//     String title = song.title;
//     String artist = song.artist ?? "";
//     String path = song.data;
//     String searchUrl = 'https://api.deezer.com/search?q=$title-$artist&limit=1&index=0&output=json';
//     print(searchUrl);
//
//     final Uri uri = Uri.parse(loginUrl).replace(queryParameters: params);
//     final http.Request postRequest = http.Request('POST', uri);
//     postRequest.headers.addAll({
//       'Content-Type': 'application/json',
//       'Cookie': 'arl=${cookies['arl']}'
//     });
//     final http.StreamedResponse streamedResponse = await postRequest.send();
//     final String postResponseString = await streamedResponse.stream.bytesToString();
//     final Map<String, dynamic> postResponseJson = jsonDecode(postResponseString);
//
//     //print(postResponseJson);
//     final String jwt = postResponseJson['jwt'];
//     //print(jwt);
//
//     final http.Response getResponse = await http.get(Uri.parse(searchUrl), headers: {
//       'Cookie': 'arl=${cookies['arl']}',
//     });
//
//     final Map<String, dynamic> getResponseJson = jsonDecode(getResponse.body);
//     //print(getResponseJson['data'][0]['id']);
//
//     final String trackId = getResponseJson['data'][0]['id'].toString();
//
//
//
//     final Map<String, dynamic> jsonData = {
//       'operationName': 'SynchronizedTrackLyrics',
//       'variables': {
//         'trackId': trackId,
//       },
//       'query': '''query SynchronizedTrackLyrics(\$trackId: String!) {
//                             track(trackId: \$trackId) {
//                               ...SynchronizedTrackLyrics
//                               __typename
//                             }
//                           }
//
//                           fragment SynchronizedTrackLyrics on Track {
//                             id
//                             lyrics {
//                               ...Lyrics
//                               __typename
//                             }
//                             album {
//                               cover {
//                                 small: urls(pictureRequest: {width: 100, height: 100})
//                                 medium: urls(pictureRequest: {width: 264, height: 264})
//                                 large: urls(pictureRequest: {width: 800, height: 800})
//                               explicitStatus
//                               __typename
//                             }
//                             __typename
//                           }
//                           __typename
//                           }
//
//                           fragment Lyrics on Lyrics {
//                             id
//                             copyright
//                             text
//                             writers
//                             synchronizedLines {
//                               ...LyricsSynchronizedLines
//                               __typename
//                             }
//                             __typename
//                           }
//
//                           fragment LyricsSynchronizedLines on LyricsSynchronizedLine {
//                             lrcTimestamp
//                             line
//                             lineTranslated
//                             milliseconds
//                             duration
//                             __typename
//                           }'''
//     };
//
//     final http.Response lyricResponse = await http.post(
//       Uri.parse(deezerApiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $jwt',
//       },
//       body: jsonEncode(jsonData),
//     );
//
//     final Map<String, dynamic> lyricResponseJson = jsonDecode(lyricResponse.body);
//     //print(lyricResponseJson);
//
//     String plainLyric = '';
//     String syncedLyric = '';
//     try{
//       plainLyric += lyricResponseJson['data']['track']['lyrics']['text'] + "\n";
//       plainLyric += "${"\nWriters: " + lyricResponseJson['data']['track']['lyrics']['writers']}\nCopyright: " + lyricResponseJson['data']['track']['lyrics']['copyright'];
//     }
//     catch(e){
//       print(e);
//       plainLyric = 'No lyrics found';
//     }
//
//     try {
//       for (var line in lyricResponseJson['data']['track']['lyrics']['synchronizedLines']) {
//         syncedLyric += "${line['lrcTimestamp']} ${line['line']}\n";
//       }
//       syncedLyric += "${"\nWriters: " + lyricResponseJson['data']['track']['lyrics']['writers']}\nCopyright: " + lyricResponseJson['data']['track']['lyrics']['copyright'];
//     } catch (e) {
//       print(e);
//       syncedLyric = 'No lyrics found';
//     }
//     //print(plainLyric);
//
//     // lyricModelNotifier.value = LyricsModelBuilder.create().bindLyricToMain(syncedLyric).getModel();
//     // plainLyricNotifier.value = plainLyric;
//
//     if(syncedLyric != 'No lyrics found'){
//       var lyrPath = path.replaceRange(path.lastIndexOf("."), path.length, ".lrc");
//       File lyrFile = File(lyrPath);
//       lyrFile.writeAsStringSync(syncedLyric);
//     }
//     else if (plainLyric != 'No lyrics found'){
//       var lyrPath = path.replaceRange(path.lastIndexOf("."), path.length, ".lrc");
//       File lyrFile = File(lyrPath);
//       lyrFile.writeAsStringSync(plainLyric);
//     }
//     return [plainLyric, syncedLyric];
//   }
//
//   void setRepeat() {
//     repeatNotifier.value = !repeatNotifier.value;
//     print("repeat: ${repeatNotifier.value}");
//   }
//
//   void setShuffle() {
//     int currentIndex = indexNotifier.value;
//     shuffleNotifier.value = !shuffleNotifier.value;
//     print("shuffle: ${shuffleNotifier.value}");
//     if (shuffleNotifier.value){
//       shuffleSongs();
//     }
//     else{
//       indexNotifier.value = settings.queue.indexOf(controllerQueue[currentIndex]);
//       controllerQueue.clear();
//       controllerQueue.addAll(settings.queue);
//     }
//     settingsBox.put(settings);
//   }
//
//   void setTimer(String time) {
//     timerNotifier.value = time;
//     switch(time){
//       case '1 minute':
//         print("1 minute");
//         sleepTimerNotifier.value = 1 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 1 minute", 3500);
//         break;
//       case '15 minutes':
//         sleepTimerNotifier.value = 15 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 15 minutes", 3500);
//         break;
//       case '30 minutes':
//         sleepTimerNotifier.value = 30 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 30 minutes", 3500);
//         break;
//       case '45 minutes':
//         sleepTimerNotifier.value = 45 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 45 minutes", 3500);
//         break;
//       case '1 hour':
//         sleepTimerNotifier.value = 1 * 60 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 1 hour", 3500);
//         break;
//       case '2 hours':
//         sleepTimerNotifier.value = 2 * 60 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 2 hours", 3500);
//         break;
//       case '3 hours':
//         sleepTimerNotifier.value = 3 * 60 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 3 hours", 3500);
//         break;
//       case '4 hours':
//         sleepTimerNotifier.value = 4 * 60 * 60 * 1000;
//         startTimer();
//         showNotification("Sleep timer set to 4 hours", 3500);
//         break;
//       default:
//         sleepTimerNotifier.value = 0;
//         showNotification("Sleep timer has been turned off", 3500);
//         break;
//     }
//   }
//
//   void showNotification(String message, int duration, {Widget actions = const SizedBox()}) {
//     if(settings.appNotifications == false){
//       return;
//     }
//     notification.value = message;
//     actions = actions;
//     Timer.periodic(
//       Duration(milliseconds: duration),
//           (timer) {
//         notification.value = '';
//         actions = const SizedBox();
//         timer.cancel();
//       },
//     );
//   }
//
//   void shuffleSongs(){
//     if(shuffleNotifier.value){
//       String current = controllerQueue[indexNotifier.value];
//       controllerQueue.shuffle();
//       indexNotifier.value = controllerQueue.indexOf(current);
//     }
//   }
//
//   void startTimer(){
//     Timer.periodic(const Duration(milliseconds: 10), (timer) {
//       if(sleepTimerNotifier.value > 0){
//         sleepTimerNotifier.value -= 10;
//       }
//       else{
//         timer.cancel();
//         audioPlayer.pause();
//         playingNotifier.value = false;
//         timerNotifier.value = 'Off';
//         showNotification("Sleep timer has ended", 3500);
//       }
//     });
//   }
//
//   Future<void> updateColors(Uint8List image) async {
//     DominantColors extractor = DominantColors(bytes: image, dominantColorsCount: 2);
//     var colors = extractor.extractDominantColors();
//     if(colors.first.computeLuminance() > 0.15 && colors.last.computeLuminance() > 0.15){
//       colorNotifier.value = colors.first;
//       colorNotifier2.value = Colors.black;
//     }
//     else if (colors.first.computeLuminance() < 0.15 && colors.last.computeLuminance() < 0.15){
//       colorNotifier.value = Colors.blue;
//       colorNotifier2.value = colors.first;
//     }
//     else{
//       if(colors.first.computeLuminance() > 0.15){
//         colorNotifier.value = colors.first;
//         colorNotifier2.value = colors.last;
//       }
//       else{
//         colorNotifier.value = colors.last;
//         colorNotifier2.value = colors.first;
//       }
//     }
//   }
//
//   Future<void> updatePlaying(List<String> songs, int index) async {
//     //loadingNotifier.value = true;
//     //print(settings.queuePlay);
//     if(settings.queuePlay == 'all'){
//       settings.queue.clear();
//       settings.queue.addAll(songs);
//       settings.index = index;
//       settingsBox.put(settings);
//       controllerQueue.clear();
//       controllerQueue.addAll(songs);
//       indexNotifier.value = index;
//       shuffleSongs();
//
//     }
//     else{
//       addToQueue([songs[index]]);
//     }
//     //loadingNotifier.value = false;
//   }
// }