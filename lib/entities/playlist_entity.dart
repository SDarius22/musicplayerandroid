import 'package:objectbox/objectbox.dart';

@Entity()
class PlaylistEntity{
  @Id()
  int id = 0;
  String name = "Unknown playlist";
  String nextAdded = "last";
  List<String> paths = [];
  bool indestructible = false;
  int duration = 0; // in seconds
  List<String> artistCount = []; // Strings of form "Artist - Count"
}