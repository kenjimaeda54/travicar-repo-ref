import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ButtonCommon extends HookWidget {
  late Color backgroundColorBtn;
  late String titleBtn;
  late Color colorTitleBtn;
  late Function() onPressed;
  ButtonCommon({Key? key, required this.backgroundColorBtn,required this.colorTitleBtn,required this.titleBtn,required this.onPressed}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
             backgroundColor: MaterialStatePropertyAll<Color>(backgroundColorBtn)
          ),
          onPressed: onPressed, child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19),
            child: Text(titleBtn, style: TextStyle(
            color: colorTitleBtn,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w700,
            fontSize: 17,
            height: 1.23
      ),),
          )),
    );
  }
}
