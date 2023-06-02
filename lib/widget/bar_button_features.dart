import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trivato/colors/ColorsApp.dart';

class ListFeatures {
  final String title;
  final String iconPath;
  final int id;

  ListFeatures({required this.title, required this.iconPath, required this.id});
}

class BarButtonFeatures extends HookWidget {
  final List<ListFeatures> features;
  final Function(int idFeature) handleClickedFeature;
  final double? widthCard;

  const BarButtonFeatures(
      {Key? key,
      required this.features,
      this.widthCard = double.infinity,
      required this.handleClickedFeature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsApp.white,
          borderRadius: BorderRadius.circular(40),
        ),
        width: widthCard,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 3, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...features
                  .map((it) => Column(
                        children: [
                          Column(children: [
                            IconButton(
                              onPressed: () => handleClickedFeature(it.id),
                              icon: SvgPicture.asset(
                                it.iconPath,
                                height: 19,
                                width: 19,
                              ),
                            ),
                            Text(
                              it.title,
                              style: TextStyle(
                                color: ColorsApp.grayBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1.1,
                              ),
                            ),
                          ])
                        ],
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
