import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trivato/colors/ColorsApp.dart';

class SimpleTextField extends HookWidget {
  final TextEditingController controller;
  final String label;
  final int? maxQuantityLenth;
  const SimpleTextField({Key? key, required this.controller,required this.label,this.maxQuantityLenth = 130}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
              color: ColorsApp.black060,
              fontSize: 15,
              height: 1.4),
        ),
        TextField(
          cursorColor: ColorsApp.black060,
          maxLines: 3,
          minLines: 1,
          maxLength: maxQuantityLenth,
          controller: controller,
          decoration: InputDecoration(
            fillColor: ColorsApp.black060,
            hoverColor: ColorsApp.black060,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorsApp.black060
              )
            )
          ),
          style: TextStyle(
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              color: ColorsApp.black060,
              fontSize: 15,
              height: 1.4),
        )
      ],
    );
  }
}
