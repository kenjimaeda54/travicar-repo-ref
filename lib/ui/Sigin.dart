import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trivato/colors/ColorsApp.dart';
import 'package:trivato/widget/ButtonCommon.dart';
import 'package:trivato/widget/TextFieldWithLabel.dart';

class Sigin extends HookWidget {
  Sigin({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsApp.grayWithe,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
            Icons.arrow_back_outlined,
            color: ColorsApp.black060),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Entrar",
            style: TextStyle(
                color: ColorsApp.black060,
                fontFamily: "Roboto",
                fontWeight: FontWeight.w700,
                fontSize: 17,
                height: 1.23),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const TextFieldWithLabel(
                    placeHolderLabel: "Digite seu email",
                    textLabel: "Email",
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const TextFieldWithLabel(
                    placeHolderLabel: "Senha",
                    textLabel: "Senha",
                    isObscure: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.18,
                          color: ColorsApp.black100),
                    ),
                  ),
                  const SizedBox(height: 53,),
                  ButtonCommon(backgroundColorBtn: ColorsApp.grayBlack, colorTitleBtn: ColorsApp.white, titleBtn: "Entrar", onPressed: (){}),
                  const SizedBox(height: 48,),
                  Divider(
                    height: 1,
                    color: ColorsApp.gray100,
                  ),
                ],
              )),
        ));
  }
}
