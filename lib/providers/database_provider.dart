import 'package:musicplayerandroid/database/objectBox.dart';
import 'package:musicplayerandroid/database/objectbox.g.dart';
import 'package:musicplayerandroid/entities/audio_info_entity.dart';
import 'package:musicplayerandroid/entities/playlist_entity.dart';
import 'package:musicplayerandroid/entities/settings_entity.dart';



class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;
  DatabaseProvider._internal(){
    initialize();
  }

  void initialize() {
    if (settingsBox.isEmpty()) {
      settingsBox.put(SettingsEntity());
    }
    if (audioInfoBox.isEmpty()) {
      audioInfoBox.put(AudioInfoEntity());
    }

  }

  get playlistBox => ObjectBox.store.box<PlaylistEntity>();
  get settingsBox => ObjectBox.store.box<SettingsEntity>();
  get audioInfoBox => ObjectBox.store.box<AudioInfoEntity>();

  get settings => settingsBox.getAll().last;
  get audioInfo => audioInfoBox.getAll().last;



  List<PlaylistEntity> queryPlaylists(String searchValue, [int? limit]) {
    var query = playlistBox
        .query(PlaylistEntity_.name.contains(searchValue, caseSensitive: false))
        .order(PlaylistEntity_.name)
        .build();
    if (limit != null) {
      query.limit = limit;
    }
    return query.find();
  }

  void updateSettings(void Function(SettingsEntity) updateFn) {
    final updatedSettings = settings;
    updateFn(updatedSettings);
    settingsBox.put(updatedSettings);
  }

  void updateAudioInfo(void Function(AudioInfoEntity) updateFn) {
    final updatedAudioInfo = audioInfo;
    updateFn(updatedAudioInfo);
    audioInfoBox.put(updatedAudioInfo);
  }

  void createPlaylist(PlaylistEntity playlist) {
    playlistBox.put(playlist);
  }

  void updatePlaylist(PlaylistEntity playlist) {
    playlistBox.put(playlist);
  }

  void deletePlaylist(PlaylistEntity playlist) {
    playlistBox.remove(playlist.id);
  }
}