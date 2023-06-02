import 'package:path_provider/path_provider.dart';

class PathAssetsDocumentsDirectory {

  static Future<String> returnPathDocuments() async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    final path = "$directory/travicar/assets";
    return path;
  }

}
