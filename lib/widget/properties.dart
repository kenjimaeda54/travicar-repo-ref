import 'package:flutter/material.dart';
import 'package:trivato/colors/ColorsApp.dart';

class Propertie {
  late final Color color;
  late final String title;

  Propertie({required this.title, required this.color});
}

class Properties {
  static List<Propertie> firstProperties = [
    propertieOne,
    propertieThree,
    propertieTwo
  ];

  static var propertieOne =
      Propertie(title: "Propriedade Um", color: ColorsApp.green);
  static var propertieThree =
      Propertie(title: "Propriedade Três", color: ColorsApp.orange);
  static var propertieTwo =
      Propertie(title: "Propriedade Dois", color: ColorsApp.red);

  static Widget buildItem(Propertie item) {
    return Row(
      children: [
        Icon(
          Icons.circle_rounded,
          color: item.color,
          size: 20,
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          item.title,
          style: TextStyle(
            color: ColorsApp.black060,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: "Roboto",
          ),
        )
      ],
    );
  }

  static handleChangeProperties(
      Propertie? value, Function(Propertie? value) completion) {
    completion(value);
  }
}
