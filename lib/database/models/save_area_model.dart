import 'package:realm/realm.dart';

part 'save_area_model.g.dart';

@RealmModel()
class _PropertiesModel {
  @PrimaryKey()
  late ObjectId id;

  late String color;
  late String titleProperties;
}

@RealmModel()
class _SaveAreaModel {
  @PrimaryKey()
  late ObjectId id;

  late String title;
  late String latitude;
  late String longitude;
  late _PropertiesModel? properties;
  late String imgPath;
}
