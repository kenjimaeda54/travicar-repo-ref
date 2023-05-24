import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trivato/colors/ColorsApp.dart';

class TextButtonIconText extends HookWidget {
  final String titleButton;
  final String assetsButton;

  const TextButtonIconText(
      {Key? key, required this.titleButton, required this.assetsButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetsButton,
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(ColorsApp.black060, BlendMode.srcIn),
              ),
              const SizedBox(
                width: 22,
              ),
              Text(
                titleButton,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ColorsApp.black060,
                ),
              )
            ],
          ),
        ));
  }
}
