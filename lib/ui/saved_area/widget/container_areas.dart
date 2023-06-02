import 'package:flutter/material.dart';
import 'package:trivato/database/models/save_area_model.dart';

import '../../../colors/ColorsApp.dart';

class ContainerAreas extends StatelessWidget {
  final SaveAreaModel area;
  final String pathDirectory;
  final Color color;

  const ContainerAreas(
      {Key? key,
      required this.area,
      required this.pathDirectory,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: ColorsApp.gray100,
          )),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                "$pathDirectory/${area.imgPath}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      area.title,
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: ColorsApp.black060),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "LAT  ${area.latitude}",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: ColorsApp.gray700),
                  ),
                  Text(
                    "LNG ${area.longitude}",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: ColorsApp.gray700),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Text(
                  area.properties!.titleProperties,
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: color),
                ))
          ],
        ),
      ),
    );
  }
}
