import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../colors/ColorsApp.dart';

class TextFieldWithLabel extends HookWidget {
  final String textLabel;
  final String placeHolderLabel;
  final bool isObscure;

  const TextFieldWithLabel(
      {Key? key, required this.placeHolderLabel, required this.textLabel, this.isObscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textLabel,
          style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: ColorsApp.black100),
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(width: 1, color: ColorsApp.gray100),
          ),
          child: CupertinoTextFormFieldRow(
            placeholder: placeHolderLabel,
            obscureText: isObscure,
            placeholderStyle: TextStyle(
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.18,
                color: ColorsApp.gray100),
            style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.18,
                color: ColorsApp.black050),
            cursorColor: ColorsApp.black,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          ),
        ),
      ],
    );
  }
}
