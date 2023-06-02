
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../colors/ColorsApp.dart';

class TopBarNotActivePolygon extends StatelessWidget {
  final GlobalKey<ScaffoldState> keyGlobal;
  const TopBarNotActivePolygon(this.keyGlobal,{Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: ColorsApp.black,
      maxLines: 5,
      maxLength: 80,
      minLines: 1,
      decoration: InputDecoration(
          counterText: "",
          label: Text(
            "Buscar...",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              height: 1.18,
              color: ColorsApp.gray,
            ),
          ),
          border: InputBorder.none,
          suffixIcon: const Icon(Icons.search,
              size: 30),
          suffixIconColor: ColorsApp.black,
          prefixIcon: Padding(
              padding:
              const EdgeInsets.symmetric(
                  horizontal: 15),
              child:
              Builder(builder: (context) {
                return IconButton(
                    icon: SvgPicture.asset(
                        "assets/icons/menu.svg",
                        colorFilter:
                        ColorFilter.mode(
                            ColorsApp.black,
                            BlendMode
                                .srcIn),
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain),
                    onPressed: () =>
                        keyGlobal
                            .currentState
                            ?.openDrawer());
              })),
          contentPadding:
          const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 14)),
    );
  }
}
