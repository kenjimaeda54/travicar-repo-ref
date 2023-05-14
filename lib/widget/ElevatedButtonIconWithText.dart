import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

import '../colors/ColorsApp.dart';

class ElevatedButtonIconWithText extends HookWidget {
  late String svgIcon;
  late String titleButton;
  late Function() handlePressButton;

  ElevatedButtonIconWithText(
      {Key? key,
      required this.svgIcon,
      required this.handlePressButton,
      required this.titleButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        elevation: MaterialStatePropertyAll<double>(0.0),
      ),
      onPressed: handlePressButton,
      icon: SvgPicture.asset(
        svgIcon,
        width: 20,
        height: 20,
      ),
      label: Text(
        titleButton,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.5,
          color: ColorsApp.grayBlack,
        ),
      ),
    );
  }
}
