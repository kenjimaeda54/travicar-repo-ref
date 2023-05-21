import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:trivato/constants/AppRoutes.dart';
import 'package:trivato/ui/Map.dart';
import 'package:trivato/ui/RegisterOrLogin.dart';
import 'package:trivato/ui/Sigin.dart';

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
        AppRoutes.sigIn: (_) =>   Sigin(),
      },
    );
  }
}
