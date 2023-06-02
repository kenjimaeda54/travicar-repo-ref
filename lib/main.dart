import 'package:flutter/material.dart';
import 'package:trivato/constants/AppRoutes.dart';
import 'package:trivato/ui/map/map.dart';
import 'package:trivato/ui/register_or_login.dart';
import 'package:trivato/ui/save_area.dart';
import 'package:trivato/ui/saved_area/saved_area.dart';
import 'package:trivato/ui/sigin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travicar App',
      theme: ThemeData(
        fontFamily: "Roboto",
        primarySwatch: Colors.blue,
      ),
      routes: {
        AppRoutes.firstRoute: (_) => const RegisterOrLogin(),
        AppRoutes.mapRoute: (_) => const MapView(),
        AppRoutes.saveArea: (_) => const SaveArea(),
        AppRoutes.savedArea: (_) =>   SavedArea(),
        AppRoutes.sigIn: (_) => Sigin(),
      },
    );
  }
}
