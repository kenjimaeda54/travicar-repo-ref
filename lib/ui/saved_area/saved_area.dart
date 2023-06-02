import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trivato/colors/ColorsApp.dart';
import 'package:trivato/database/config/realm_database.dart';
import 'package:trivato/ui/saved_area/widget/container_areas.dart';
import 'package:trivato/utils/path_assets_documents_directory.dart';
import 'package:trivato/widget/drawer_navigation.dart';

import '../../database/models/save_area_model.dart';

class SavedArea extends HookWidget {
  SavedArea({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scafooldkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final selectedProperites = useState<String?>(null);
    final pathDirectory = useState("");
    final saveAreas = useState<List<SaveAreaModel>>([]);
    final listStrings = [
      "Propriedade um",
      "Propriedade dois",
      "Propriedade tres"
    ];

    handlePathDirectory() async {
      final path = await PathAssetsDocumentsDirectory.returnPathDocuments();
      pathDirectory.value = path;
    }

    useEffect(() {
      final saveArea = RealmDatabase.realm.all<SaveAreaModel>();
      for (var element in saveArea) {
        final saveArea = SaveAreaModel(element.id, element.title,
            element.latitude, element.longitude, element.imgPath,
            properties: element.properties);

        final existArea = saveAreas.value
            .firstWhereOrNull((element) => element.id == saveArea.id);
        if (existArea != null) return;
        saveAreas.value = [...saveAreas.value, saveArea];
      }
      handlePathDirectory();
    });

    handleChangeProperties(String? value) {
      selectedProperites.value = value;
    }

    return Scaffold(
      key: _scafooldkey,
      drawer: const DrawerNavigation(),
      appBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
        backgroundColor: ColorsApp.grayBlack,
        leading: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          IconButton(
            onPressed: () => _scafooldkey.currentState?.openDrawer(),
            icon: SvgPicture.asset(
              "assets/icons/menu.svg",
              width: 28,
              height: 28,
              colorFilter:
                  ColorFilter.mode(ColorsApp.grayWithe, BlendMode.srcIn),
            ),
          ),
          Text(
            "Áreas salvas",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                height: 1.17,
                color: ColorsApp.grayWithe),
          ),
        ]),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/search.svg",
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(ColorsApp.grayWithe, BlendMode.srcIn),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/copy_save.svg",
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(ColorsApp.grayWithe, BlendMode.srcIn),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/icons/filter.svg",
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(ColorsApp.grayWithe, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                      enableFeedback: true,
                      customButton: Container(
                        width: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 1,
                                color: ColorsApp.gray700,
                                style: BorderStyle.solid)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedProperites.value ??
                                    "Todas as propriedades",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400,
                                    color: ColorsApp.gray700),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              SvgPicture.asset(
                                "assets/icons/arrow_down.svg",
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                    ColorsApp.gray700, BlendMode.srcIn),
                              )
                            ],
                          ),
                        ),
                      ),
                      value: selectedProperites.value,
                      buttonStyleData: ButtonStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            width: 1,
                            color: ColorsApp.gray100,
                          ),
                        ),
                      ),
                      onChanged: handleChangeProperties,
                      items: [
                        ...listStrings.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400,
                                    color: ColorsApp.gray700),
                              ),
                            ))
                      ]),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: saveAreas.value.length,
                  itemBuilder: (context, index) {
                    String valueString = saveAreas
                        .value[index].properties!.color
                        .split('(0x')[1]
                        .split(')')[0];
                    int value = int.parse(valueString, radix: 16);
                    final color = Color(value);
                    return pathDirectory.value.length <= 2
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: ContainerAreas(
                              area: saveAreas.value[index],
                              pathDirectory: pathDirectory.value,
                              color: color,
                            ),
                          );
                  })
            ]),
      ),
    );
  }
}
