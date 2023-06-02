import 'package:realm/realm.dart';
import 'package:trivato/database/models/save_area_model.dart';

class RealmDatabase {
  static final _config =
      Configuration.local([SaveAreaModel.schema, PropertiesModel.schema]);
  static var realm = Realm(_config);
}
