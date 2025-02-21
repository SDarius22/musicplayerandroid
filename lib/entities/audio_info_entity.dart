import 'package:objectbox/objectbox.dart';

@Entity()
class AudioInfoEntity{
  @Id()
  int id = 0;

  int index = 0; // this is the index of the song in the unshuffled queue
  int slider = 0; // milliseconds
  bool playing = false;
  bool repeat = false;
  bool shuffle = false;
  double balance = 0;
  double speed = 1;
  double volume = 0.5;
  int sleepTimer = 0; // milliseconds
  List<String> unshuffledQueue = [];
  List<String> shuffledQueue = [];
}