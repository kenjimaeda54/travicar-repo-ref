import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:realm/realm.dart';
import 'package:trivato/constants/AppRoutes.dart';
import 'package:trivato/database/config/realm_database.dart';
import 'package:trivato/database/models/save_area_model.dart';
import 'package:trivato/ui/map/map.dart';
import 'package:trivato/widget/button_common.dart';
import 'package:trivato/widget/properties.dart';
import 'package:trivato/widget/simple_text_field.dart';

import '../colors/ColorsApp.dart';

class SaveArea extends HookWidget {
  const SaveArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as ArgumentsSaveArea;
    var textDescriptionController = useTextEditingController();
    var textTitleController = useTextEditingController();
    var isCheckedExclusionZone = useState(false);
    final listClientes = ["João", "Pereira", 'Carlos'];
    final selectedNameClient = useState<String?>(null);
    final selectedProperites = useState<Propertie?>(null);
    var activeBtn = textTitleController.text.length >= 3 &&
        textDescriptionController.text.length >= 3 &&
        selectedProperites.value != null;

    handleClickCheckbox() {
      isCheckedExclusionZone.value = !isCheckedExclusionZone.value;
    }

    handleChangedNameClient(String? value) {
      selectedNameClient.value = value;
    }

    handleSave() {
      final properties = PropertiesModel(
          ObjectId(),
          selectedProperites.value!.color.toString(),
          selectedProperites.value!.title);
      final saveArea = SaveAreaModel(
          ObjectId(),
          textTitleController.text,
          "${arguments.locationUser.latitude}",
          "${arguments.locationUser.longitude}",
          arguments.fileName,
          properties: properties);

      RealmDatabase.realm.write(() => {
            RealmDatabase.realm.add(saveArea),
          });

      Navigator.of(context).pushReplacementNamed(AppRoutes.savedArea);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined, color: ColorsApp.black060),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Salvar Área",
            style: TextStyle(
                color: ColorsApp.black060,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
                fontSize: 17,
                height: 1.23),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informações do PDI",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: ColorsApp.gray200,
                        fontFamily: "Roboto"),
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  SimpleTextField(
                    controller: textTitleController,
                    label: "Título",
                    maxQuantityLenth: 21,
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  SimpleTextField(
                    controller: textDescriptionController,
                    label: "Descrição",
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  SizedBox(
                      child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: OutlinedButton(
                            onPressed: handleClickCheckbox,
                            style: ButtonStyle(
                                backgroundColor: isCheckedExclusionZone.value
                                    ? MaterialStatePropertyAll<Color>(
                                        ColorsApp.black060)
                                    : const MaterialStatePropertyAll<Color>(
                                        Colors.transparent)),
                            child: Container()),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Zona de exclusão",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: ColorsApp.black,
                            fontFamily: "Roboto"),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 28,
                  ),
                  Text(
                    "Cliente",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.black060,
                        fontSize: 15,
                        height: 1.4),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                          hint: Text(
                            "Nome dos clientes",
                            style: TextStyle(
                              color: ColorsApp.black060,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    width: 1,
                                    color: ColorsApp.gray100,
                                  ))),
                          value: selectedNameClient.value,
                          onChanged: handleChangedNameClient,
                          items: listClientes
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                        color: ColorsApp.black060,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "Propriedade",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.black060,
                        fontSize: 15,
                        height: 1.4),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<Propertie>(
                          hint: Row(
                            children: [
                              Icon(
                                Icons.circle_rounded,
                                color: ColorsApp.blueLigth,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Sem vínculo",
                                style: TextStyle(
                                  color: ColorsApp.black060,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ],
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 1,
                                color: ColorsApp.gray100,
                              ),
                            ),
                          ),
                          value: selectedProperites.value,
                          onChanged: (value) =>
                              Properties.handleChangeProperties(value,
                                  (value) => selectedProperites.value = value),
                          items: [
                            ...Properties.firstProperties.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Properties.buildItem(e),
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 40,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: activeBtn ? 1 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: activeBtn
                    ? ButtonCommon(
                        backgroundColorBtn: ColorsApp.grayBlack,
                        colorTitleBtn: ColorsApp.white,
                        titleBtn: "Salvar",
                        onPressed: handleSave)
                    : ButtonCommon(
                        backgroundColorBtn: ColorsApp.grayBlack,
                        colorTitleBtn: ColorsApp.white,
                        titleBtn: "Salvar",
                        onPressed: null),
              ),
            )
          ],
        ));
  }
}
