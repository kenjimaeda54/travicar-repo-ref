import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trivato/colors/ColorsApp.dart';
import 'package:trivato/constants/AppRoutes.dart';
import 'package:trivato/widget/ButtonCommon.dart';

class RegisterOrLogin extends HookWidget {
  const RegisterOrLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.grayBlack,
      body: Container(
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png",
                    width: 280,
                    height: 82,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high),
                const SizedBox(height: 76),
                Text(
                  "Bem vindo (a)",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 34,
                      height: 1.30,
                      color: ColorsApp.grayWithe),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonCommon(
                    backgroundColorBtn: ColorsApp.red,
                    colorTitleBtn: ColorsApp.white,
                    titleBtn: 'Entrar',
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.sigIn),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonCommon(
                    backgroundColorBtn: ColorsApp.grayWithe,
                    colorTitleBtn: ColorsApp.black050,
                    titleBtn: 'Cadastrar',
                    onPressed: (){},
                  ),
                ),
              ],
            ),
              Positioned(
                bottom: 74,
                child: Text(
                  "Continuar sem cadastro",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorsApp.grayWithe,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      height: 1.23
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
