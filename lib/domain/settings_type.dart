import 'package:objectbox/objectbox.dart';

@Entity()
class Settings{
  @Id()
  int id = 0;
  String directory = '/';
  int index = 0; // this is the index of the song in the unshuffled queue
  bool firstTime = true;
  bool systemTray = true;
  bool fullClose = false;
  bool appNotifications = true;
  String deezerARL = '';
  String queueAdd = 'last';
  String queuePlay = 'all';
  List<String> queue = []; // this is the queue of songs, unshuffled
  List<String> missingSongs = []; // this is the list of songs that are missing from the library

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'firstTime': firstTime,
      'systemTray': systemTray,
      'fullClose': fullClose,
      'appNotifications': appNotifications,
      'deezerARL': deezerARL,
      'queueAdd': queueAdd,
      'queuePlay': queuePlay,
      'queue': queue,
      'missingSongs': missingSongs,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    index = map['index'];
    firstTime = map['firstTime'];
    systemTray = map['systemTray'];
    fullClose = map['fullClose'];
    appNotifications = map['appNotifications'];
    deezerARL = map['deezerARL'];
    queueAdd = map['queueAdd'];
    queuePlay = map['queuePlay'];
    queue = map['queue'];
    missingSongs = map['missingSongs'];
  }
}