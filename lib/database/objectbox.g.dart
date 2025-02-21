// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import '../entities/audio_info_entity.dart';
import '../entities/playlist_entity.dart';
import '../entities/settings_entity.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 6475817503884992334),
      name: 'AudioInfoEntity',
      lastPropertyId: const obx_int.IdUid(12, 8172387153617920685),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8024752574304966094),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1321722112705283482),
            name: 'index',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6572891975965212105),
            name: 'slider',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 4930347703317401781),
            name: 'playing',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 3636257167648916869),
            name: 'repeat',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4732428092451459897),
            name: 'shuffle',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 8237125804775246284),
            name: 'balance',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 1635939563884530019),
            name: 'speed',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 5441477261385327028),
            name: 'volume',
            type: 8,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 4555833233631978316),
            name: 'sleepTimer',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 6945848897626077896),
            name: 'unshuffledQueue',
            type: 30,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 8172387153617920685),
            name: 'shuffledQueue',
            type: 30,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 8346723063786815593),
      name: 'SettingsEntity',
      lastPropertyId: const obx_int.IdUid(12, 7953600668163766535),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 367144236346629282),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 1746535356425136073),
            name: 'mongoID',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 4806434561410171765),
            name: 'email',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 6162678982508880446),
            name: 'password',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 9005461726508595937),
            name: 'deviceList',
            type: 30,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4872954874166789171),
            name: 'primaryDevice',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 3005153802014822360),
            name: 'missingSongs',
            type: 30,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(8, 4769189093889613144),
            name: 'deezerARL',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(9, 3939145697263571899),
            name: 'firstTime',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(10, 6034367794116484669),
            name: 'appNotifications',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(11, 6806715642847333550),
            name: 'queueAdd',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(12, 7953600668163766535),
            name: 'queuePlay',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(4, 2810442586152317323),
      name: 'PlaylistEntity',
      lastPropertyId: const obx_int.IdUid(7, 2422582797900601477),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7998403278185998845),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 8883917865529417898),
            name: 'name',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7680448273446002483),
            name: 'nextAdded',
            type: 9,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 5804201527903265665),
            name: 'paths',
            type: 30,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 4747557842830407309),
            name: 'indestructible',
            type: 1,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(6, 4226624031330163625),
            name: 'duration',
            type: 6,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(7, 2422582797900601477),
            name: 'artistCount',
            type: 30,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
Future<obx.Store> openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) async {
  await loadObjectBoxLibraryAndroidCompat();
  return obx.Store(getObjectBoxModel(),
      directory: directory ?? (await defaultStoreDirectory()).path,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(4, 2810442586152317323),
      lastIndexId: const obx_int.IdUid(0, 0),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [6426190992824815165],
      retiredIndexUids: const [],
      retiredPropertyUids: const [
        3168607470222552944,
        7137180191704235,
        5927443724938116562,
        4373692054529818470,
        5223673534744241007,
        4273272341667789738,
        4090369904269081461
      ],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    AudioInfoEntity: obx_int.EntityDefinition<AudioInfoEntity>(
        model: _entities[0],
        toOneRelations: (AudioInfoEntity object) => [],
        toManyRelations: (AudioInfoEntity object) => {},
        getId: (AudioInfoEntity object) => object.id,
        setId: (AudioInfoEntity object, int id) {
          object.id = id;
        },
        objectToFB: (AudioInfoEntity object, fb.Builder fbb) {
          final unshuffledQueueOffset = fbb.writeList(object.unshuffledQueue
              .map(fbb.writeString)
              .toList(growable: false));
          final shuffledQueueOffset = fbb.writeList(object.shuffledQueue
              .map(fbb.writeString)
              .toList(growable: false));
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.index);
          fbb.addInt64(2, object.slider);
          fbb.addBool(3, object.playing);
          fbb.addBool(4, object.repeat);
          fbb.addBool(5, object.shuffle);
          fbb.addFloat64(6, object.balance);
          fbb.addFloat64(7, object.speed);
          fbb.addFloat64(8, object.volume);
          fbb.addInt64(9, object.sleepTimer);
          fbb.addOffset(10, unshuffledQueueOffset);
          fbb.addOffset(11, shuffledQueueOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = AudioInfoEntity()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..index = const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0)
            ..slider =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)
            ..playing =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 10, false)
            ..repeat =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 12, false)
            ..shuffle =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 14, false)
            ..balance =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 16, 0)
            ..speed =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 18, 0)
            ..volume =
                const fb.Float64Reader().vTableGet(buffer, rootOffset, 20, 0)
            ..sleepTimer =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 22, 0)
            ..unshuffledQueue = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 24, [])
            ..shuffledQueue = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 26, []);

          return object;
        }),
    SettingsEntity: obx_int.EntityDefinition<SettingsEntity>(
        model: _entities[1],
        toOneRelations: (SettingsEntity object) => [],
        toManyRelations: (SettingsEntity object) => {},
        getId: (SettingsEntity object) => object.id,
        setId: (SettingsEntity object, int id) {
          object.id = id;
        },
        objectToFB: (SettingsEntity object, fb.Builder fbb) {
          final mongoIDOffset = fbb.writeString(object.mongoID);
          final emailOffset = fbb.writeString(object.email);
          final passwordOffset = fbb.writeString(object.password);
          final deviceListOffset = fbb.writeList(
              object.deviceList.map(fbb.writeString).toList(growable: false));
          final primaryDeviceOffset = fbb.writeString(object.primaryDevice);
          final missingSongsOffset = fbb.writeList(
              object.missingSongs.map(fbb.writeString).toList(growable: false));
          final deezerARLOffset = fbb.writeString(object.deezerARL);
          final queueAddOffset = fbb.writeString(object.queueAdd);
          final queuePlayOffset = fbb.writeString(object.queuePlay);
          fbb.startTable(13);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, mongoIDOffset);
          fbb.addOffset(2, emailOffset);
          fbb.addOffset(3, passwordOffset);
          fbb.addOffset(4, deviceListOffset);
          fbb.addOffset(5, primaryDeviceOffset);
          fbb.addOffset(6, missingSongsOffset);
          fbb.addOffset(7, deezerARLOffset);
          fbb.addBool(8, object.firstTime);
          fbb.addBool(9, object.appNotifications);
          fbb.addOffset(10, queueAddOffset);
          fbb.addOffset(11, queuePlayOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = SettingsEntity()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..mongoID = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..email = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '')
            ..password = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 10, '')
            ..deviceList = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 12, [])
            ..primaryDevice = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 14, '')
            ..missingSongs = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 16, [])
            ..deezerARL = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 18, '')
            ..firstTime =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 20, false)
            ..appNotifications =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 22, false)
            ..queueAdd = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 24, '')
            ..queuePlay = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 26, '');

          return object;
        }),
    PlaylistEntity: obx_int.EntityDefinition<PlaylistEntity>(
        model: _entities[2],
        toOneRelations: (PlaylistEntity object) => [],
        toManyRelations: (PlaylistEntity object) => {},
        getId: (PlaylistEntity object) => object.id,
        setId: (PlaylistEntity object, int id) {
          object.id = id;
        },
        objectToFB: (PlaylistEntity object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final nextAddedOffset = fbb.writeString(object.nextAdded);
          final pathsOffset = fbb.writeList(
              object.paths.map(fbb.writeString).toList(growable: false));
          final artistCountOffset = fbb.writeList(
              object.artistCount.map(fbb.writeString).toList(growable: false));
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, nextAddedOffset);
          fbb.addOffset(3, pathsOffset);
          fbb.addBool(4, object.indestructible);
          fbb.addInt64(5, object.duration);
          fbb.addOffset(6, artistCountOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PlaylistEntity()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..name = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 6, '')
            ..nextAdded = const fb.StringReader(asciiOptimization: true)
                .vTableGet(buffer, rootOffset, 8, '')
            ..paths = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 10, [])
            ..indestructible =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 12, false)
            ..duration =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 14, 0)
            ..artistCount = const fb.ListReader<String>(
                    fb.StringReader(asciiOptimization: true),
                    lazy: false)
                .vTableGet(buffer, rootOffset, 16, []);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [AudioInfoEntity] entity fields to define ObjectBox queries.
class AudioInfoEntity_ {
  /// See [AudioInfoEntity.id].
  static final id =
      obx.QueryIntegerProperty<AudioInfoEntity>(_entities[0].properties[0]);

  /// See [AudioInfoEntity.index].
  static final index =
      obx.QueryIntegerProperty<AudioInfoEntity>(_entities[0].properties[1]);

  /// See [AudioInfoEntity.slider].
  static final slider =
      obx.QueryIntegerProperty<AudioInfoEntity>(_entities[0].properties[2]);

  /// See [AudioInfoEntity.playing].
  static final playing =
      obx.QueryBooleanProperty<AudioInfoEntity>(_entities[0].properties[3]);

  /// See [AudioInfoEntity.repeat].
  static final repeat =
      obx.QueryBooleanProperty<AudioInfoEntity>(_entities[0].properties[4]);

  /// See [AudioInfoEntity.shuffle].
  static final shuffle =
      obx.QueryBooleanProperty<AudioInfoEntity>(_entities[0].properties[5]);

  /// See [AudioInfoEntity.balance].
  static final balance =
      obx.QueryDoubleProperty<AudioInfoEntity>(_entities[0].properties[6]);

  /// See [AudioInfoEntity.speed].
  static final speed =
      obx.QueryDoubleProperty<AudioInfoEntity>(_entities[0].properties[7]);

  /// See [AudioInfoEntity.volume].
  static final volume =
      obx.QueryDoubleProperty<AudioInfoEntity>(_entities[0].properties[8]);

  /// See [AudioInfoEntity.sleepTimer].
  static final sleepTimer =
      obx.QueryIntegerProperty<AudioInfoEntity>(_entities[0].properties[9]);

  /// See [AudioInfoEntity.unshuffledQueue].
  static final unshuffledQueue = obx.QueryStringVectorProperty<AudioInfoEntity>(
      _entities[0].properties[10]);

  /// See [AudioInfoEntity.shuffledQueue].
  static final shuffledQueue = obx.QueryStringVectorProperty<AudioInfoEntity>(
      _entities[0].properties[11]);
}

/// [SettingsEntity] entity fields to define ObjectBox queries.
class SettingsEntity_ {
  /// See [SettingsEntity.id].
  static final id =
      obx.QueryIntegerProperty<SettingsEntity>(_entities[1].properties[0]);

  /// See [SettingsEntity.mongoID].
  static final mongoID =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[1]);

  /// See [SettingsEntity.email].
  static final email =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[2]);

  /// See [SettingsEntity.password].
  static final password =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[3]);

  /// See [SettingsEntity.deviceList].
  static final deviceList =
      obx.QueryStringVectorProperty<SettingsEntity>(_entities[1].properties[4]);

  /// See [SettingsEntity.primaryDevice].
  static final primaryDevice =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[5]);

  /// See [SettingsEntity.missingSongs].
  static final missingSongs =
      obx.QueryStringVectorProperty<SettingsEntity>(_entities[1].properties[6]);

  /// See [SettingsEntity.deezerARL].
  static final deezerARL =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[7]);

  /// See [SettingsEntity.firstTime].
  static final firstTime =
      obx.QueryBooleanProperty<SettingsEntity>(_entities[1].properties[8]);

  /// See [SettingsEntity.appNotifications].
  static final appNotifications =
      obx.QueryBooleanProperty<SettingsEntity>(_entities[1].properties[9]);

  /// See [SettingsEntity.queueAdd].
  static final queueAdd =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[10]);

  /// See [SettingsEntity.queuePlay].
  static final queuePlay =
      obx.QueryStringProperty<SettingsEntity>(_entities[1].properties[11]);
}

/// [PlaylistEntity] entity fields to define ObjectBox queries.
class PlaylistEntity_ {
  /// See [PlaylistEntity.id].
  static final id =
      obx.QueryIntegerProperty<PlaylistEntity>(_entities[2].properties[0]);

  /// See [PlaylistEntity.name].
  static final name =
      obx.QueryStringProperty<PlaylistEntity>(_entities[2].properties[1]);

  /// See [PlaylistEntity.nextAdded].
  static final nextAdded =
      obx.QueryStringProperty<PlaylistEntity>(_entities[2].properties[2]);

  /// See [PlaylistEntity.paths].
  static final paths =
      obx.QueryStringVectorProperty<PlaylistEntity>(_entities[2].properties[3]);

  /// See [PlaylistEntity.indestructible].
  static final indestructible =
      obx.QueryBooleanProperty<PlaylistEntity>(_entities[2].properties[4]);

  /// See [PlaylistEntity.duration].
  static final duration =
      obx.QueryIntegerProperty<PlaylistEntity>(_entities[2].properties[5]);

  /// See [PlaylistEntity.artistCount].
  static final artistCount =
      obx.QueryStringVectorProperty<PlaylistEntity>(_entities[2].properties[6]);
}
