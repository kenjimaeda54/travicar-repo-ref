import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../colors/ColorsApp.dart';

class TopBarActivePolygon extends HookWidget {
  final Function() onPressedSaveArea;
  final Function() onPressDesativeArea;
  final bool isActiveBtn;

  const TopBarActivePolygon(
      {Key? key,
      required this.onPressedSaveArea,
      required this.isActiveBtn,
      required this.onPressDesativeArea})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RichText(
                  text: TextSpan(
                      text: "LAT",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.5,
                        color: ColorsApp.grayBlack,
                      ),
                      children: [
                    TextSpan(
                        text: "302",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                          color: ColorsApp.grayBlack,
                        ))
                  ])),
              RichText(
                  text: TextSpan(
                      text: "LNG",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.5,
                        color: ColorsApp.grayBlack,
                      ),
                      children: [
                    TextSpan(
                        text: "402",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                          color: ColorsApp.grayBlack,
                        ))
                  ])),
            ]),
          ),
          SizedBox(
            child: Row(
              children: [
                AnimatedOpacity(
                  opacity: isActiveBtn ? 1 : 0.5,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  child: IconButton(
                      onPressed: isActiveBtn ? onPressedSaveArea : null,
                      icon: const Icon(Icons.save)),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onPressDesativeArea,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
