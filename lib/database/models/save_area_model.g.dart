// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_area_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class PropertiesModel extends _PropertiesModel
    with RealmEntity, RealmObjectBase, RealmObject {
  PropertiesModel(
    ObjectId id,
    String color,
    String titleProperties,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'titleProperties', titleProperties);
  }

  PropertiesModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get color => RealmObjectBase.get<String>(this, 'color') as String;
  @override
  set color(String value) => RealmObjectBase.set(this, 'color', value);

  @override
  String get titleProperties =>
      RealmObjectBase.get<String>(this, 'titleProperties') as String;
  @override
  set titleProperties(String value) =>
      RealmObjectBase.set(this, 'titleProperties', value);

  @override
  Stream<RealmObjectChanges<PropertiesModel>> get changes =>
      RealmObjectBase.getChanges<PropertiesModel>(this);

  @override
  PropertiesModel freeze() =>
      RealmObjectBase.freezeObject<PropertiesModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(PropertiesModel._);
    return const SchemaObject(
        ObjectType.realmObject, PropertiesModel, 'PropertiesModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('color', RealmPropertyType.string),
      SchemaProperty('titleProperties', RealmPropertyType.string),
    ]);
  }
}

class SaveAreaModel extends _SaveAreaModel
    with RealmEntity, RealmObjectBase, RealmObject {
  SaveAreaModel(
    ObjectId id,
    String title,
    String latitude,
    String longitude,
    String imgPath, {
    PropertiesModel? properties,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'properties', properties);
    RealmObjectBase.set(this, 'imgPath', imgPath);
  }

  SaveAreaModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String;
  @override
  set latitude(String value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  String get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String;
  @override
  set longitude(String value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  PropertiesModel? get properties =>
      RealmObjectBase.get<PropertiesModel>(this, 'properties')
          as PropertiesModel?;
  @override
  set properties(covariant PropertiesModel? value) =>
      RealmObjectBase.set(this, 'properties', value);

  @override
  String get imgPath => RealmObjectBase.get<String>(this, 'imgPath') as String;
  @override
  set imgPath(String value) => RealmObjectBase.set(this, 'imgPath', value);

  @override
  Stream<RealmObjectChanges<SaveAreaModel>> get changes =>
      RealmObjectBase.getChanges<SaveAreaModel>(this);

  @override
  SaveAreaModel freeze() => RealmObjectBase.freezeObject<SaveAreaModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(SaveAreaModel._);
    return const SchemaObject(
        ObjectType.realmObject, SaveAreaModel, 'SaveAreaModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.string),
      SchemaProperty('longitude', RealmPropertyType.string),
      SchemaProperty('properties', RealmPropertyType.object,
          optional: true, linkTarget: 'PropertiesModel'),
      SchemaProperty('imgPath', RealmPropertyType.string),
    ]);
  }
}
