import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trivato/widget/TextButtonIconText.dart';

class DrawerNavigation extends HookWidget {
 const  DrawerNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: SizedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    child: SvgPicture.asset(
                      "assets/icons/profile_without_photo.svg",
                      width: 59,
                      height: 59,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("Entrar",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              fontSize: 16,
                            )),
                        SizedBox(
                          height: 9,
                        ),
                        Text(
                          "Inicie a sessão para salvar suas medições",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/areas.svg",
            titleButton: "Áreas",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/areas_save.svg",
            titleButton: "Áreas salvas",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/properties.svg",
            titleButton: "Propriedades",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/sync_now.svg",
            titleButton: "Sincronizar agora",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/import_pen_drive.svg",
            titleButton: "Importar do pen-drive",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/config.svg",
            titleButton: "Configurações",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/chat.svg",
            titleButton: "Contate-nos via Whatsapp",
          ),
          const TextButtonIconText(
            assetsButton: "assets/icons/apps_agriculture.svg",
            titleButton: "Apps para agricultores",
          ),
        ],
      ),
    );
  }
}
