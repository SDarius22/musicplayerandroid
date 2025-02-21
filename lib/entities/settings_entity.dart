import 'package:objectbox/objectbox.dart';

@Entity()
class SettingsEntity{
  @Id()
  int id = 0;

  String mongoID = '';
  String email = '';
  String password = '';
  List<String> deviceList = [];
  String primaryDevice = '';
  List<String> missingSongs = []; // this is the list of songs that are missing from the library

  String deezerARL = '';

  bool firstTime = true;
  bool appNotifications = true;
  String queueAdd = 'last';
  String queuePlay = 'all';


  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'deviceList': deviceList,
      'primaryDevice': primaryDevice,
      'firstTime': firstTime,
      'appNotifications': appNotifications,
      'deezerARL': deezerARL,
      'queueAdd': queueAdd,
      'queuePlay': queuePlay,
      'missingSongs': missingSongs,
    };
  }

  void fromMap(Map<String, dynamic> map) {
    mongoID = map['id'];
    deviceList = List<String>.from(map['deviceList']);
    primaryDevice = map['primaryDevice'];
    firstTime = map['firstTime'];
    appNotifications = map['appNotifications'];
    deezerARL = map['deezerARL'];
    queueAdd = map['queueAdd'];
    queuePlay = map['queuePlay'];
    missingSongs = List<String>.from(map['missingSongs']);
  }
}