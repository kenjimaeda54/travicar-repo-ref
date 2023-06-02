import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_map_line_editor/flutter_map_line_editor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:realm/realm.dart';
import 'package:screenshot/screenshot.dart';
import 'package:trivato/colors/ColorsApp.dart';
import 'package:trivato/constants/AppRoutes.dart';
import 'package:trivato/ui/map/widget/top_bar_active_polygon.dart';
import 'package:trivato/ui/map/widget/top_bar_not_active_polygon.dart';
import 'package:trivato/utils/path_assets_documents_directory.dart';
import 'package:trivato/widget/bar_button_features.dart';
import 'package:trivato/widget/drawer_navigation.dart';
import 'package:trivato/widget/elevated_button_icon_with_text.dart';

class ArgumentsSaveArea {
  late final LatLng locationUser;
  late final String fileName;

  ArgumentsSaveArea({required this.fileName, required this.locationUser});
}

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  final MapController _mapController = MapController();
  LatLng _locationUser = LatLng(0.0, 0.0);
  var _activeSaveArea = false;
  final List<LatLng> _pointsLine = [];
  bool _activeLines = false;
  bool _activePoligon = false;
  LatLng _lastPointRemoved = LatLng(0.0, 0.0);
  late PolyEditor _polyEditor;
  var _isVisibleTypeMaps = false;
  final List<String> _typeMap = [
    'https://api.mapbox.com/styles/v1/kenjimaeda/clhnjjmrg039d01pa3bz482gg/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
    'https://api.mapbox.com/styles/v1/kenjimaeda/clhnkj63s034j01qm14d64liu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
    'https://api.mapbox.com/styles/v1/kenjimaeda/clhj1egsu02u801pa8yd48xcy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg'
  ];
  var _typeMapSelected = "";
  final List<Polygon> _polygons = [];

  final List<ListFeatures> _features = [
    ListFeatures(title: "Pivô", iconPath: "assets/icons/pivot.svg", id: 1),
    ListFeatures(
        title: "Polígono", iconPath: "assets/icons/polygon.svg", id: 2),
    ListFeatures(title: "Régua", iconPath: "assets/icons/ruler.svg", id: 3),
  ];

  final List<ListFeatures> _featureClicked = [
    ListFeatures(title: "", iconPath: "assets/icons/new_polygon.svg", id: 1),
    ListFeatures(title: "", iconPath: "assets/icons/edit.svg", id: 2),
    ListFeatures(title: "", iconPath: "assets/icons/back.svg", id: 3),
    ListFeatures(title: "", iconPath: "assets/icons/forward.svg", id: 4),
    ListFeatures(title: "", iconPath: "assets/icons/delete.svg", id: 5),
    ListFeatures(title: "", iconPath: "assets/icons/cut_area.svg", id: 6),
  ];

  final _firstPolygon = Polygon(
      color: const Color.fromRGBO(144, 238, 144, 0.5),
      isFilled: true,
      points: [],
      isDotted: true);

  handleTapMap(_, LatLng position) {
    if (_polyEditor.points.isNotEmpty) {
      setState(() {
        _activeSaveArea = true;
      });
    }

    if (_activePoligon) {
      setState(() {
        _polyEditor.add(_firstPolygon.points, position);
      });
      return;
    }

    if (_activeLines && _pointsLine.length <= 1) {
      setState(() {
        _pointsLine.add(position);
      });
      return;
    }

    return null;
  }

  _handleEditFeature() {
    print("edit");
  }

  _handleDeleteFeature() {
    setState(() {
      //LatLng(latitude:-22.228447, longitude:-45.945438)/
    });
  }

  _handleRemoveLastPoint() {
    setState(() {
      final points = _polyEditor.remove(_polyEditor.points.length - 1);
      _lastPointRemoved = points;
    });
  }

  _handleAddLastPoint() {
    setState(() {
      _polyEditor.add(_firstPolygon.points, _lastPointRemoved);
    });
  }

  _handleFeatureClicked(int id) {
    switch (id) {
      case 2:
        _handleEditFeature();
        break;
      case 5:
        _handleDeleteFeature();
        break;
      case 3:
        _handleRemoveLastPoint();
        break;

      case 4:
        _handleAddLastPoint();
        break;
    }
  }

  _handleFeature(int id) {
    final feature = _features.firstWhere((element) => element.id == id);

    if (feature.title == "Polígono") {
      setState(() {
        _activePoligon = true;
      });
    }
    if (feature.title == "Régua") {
      setState(() {
        _activeLines = true;
        _activePoligon = false;
      });
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    _polyEditor = PolyEditor(
      addClosePathMarker: false,
      points: _firstPolygon.points,
      pointIcon: const Icon(Icons.circle,
          size: 18, color: Color.fromRGBO(255, 255, 255, 0.7)),
      intermediateIcon: const Icon(Icons.circle,
          size: 15, color: Color.fromRGBO(255, 255, 255, 0.7)),
      callbackRefresh: () => {setState(() {})},
    );

    _polygons.add(_firstPolygon);

    setState(() {
      _typeMapSelected = _typeMap[0];
    });
  }

  _handleVisibleTypeMap() {
    setState(() {
      _isVisibleTypeMaps = !_isVisibleTypeMaps;
    });
  }

  _getLocationUser() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _locationUser = LatLng(position.latitude, position.longitude);
        _mapController.move(LatLng(position.latitude, position.longitude), 17);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  _handlePressSaveArea() async {
    final uid = Uuid.v4();
    final path = await PathAssetsDocumentsDirectory.returnPathDocuments();
    String fileName = "$uid.png";
    screenshotController.captureAndSave(path, fileName: fileName);
    final arguments =
        ArgumentsSaveArea(fileName: fileName, locationUser: _locationUser);
    Navigator.of(context).pushNamed(AppRoutes.saveArea, arguments: arguments);
  }

  _handlePressDisableSaveArea() {
    setState(() {
      _activePoligon = false;
      _polyEditor.points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pointsLine.length == 2) {
      final distance = Geolocator.distanceBetween(
          _pointsLine[0].latitude,
          _pointsLine[0].longitude,
          _pointsLine[1].latitude,
          _pointsLine[0].longitude);
      print(distance);
      //TODO: - AQUI recuperamos a distancia entre os dois pontos
    }

    return Scaffold(
        key: _key,
        drawer: const DrawerNavigation(),
        body: Stack(children: [
          Screenshot(
            controller: screenshotController,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(-18.1778564, -54.8739394),
                zoom: 4,
                onTap: handleTapMap,
              ),
              children: [
                TileLayer(
                  urlTemplate: _typeMapSelected,
                  additionalOptions: const {
                    'accessToken':
                        'pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
                  },
                ),
                PolygonLayer(polygons: _polygons),
                DragMarkers(markers: _polyEditor.edit()),
                if (_activeLines && _pointsLine.isNotEmpty)
                  PolylineLayer(
                    polylineCulling: true,
                    polylines: [
                      Polyline(
                          points: _pointsLine,
                          color: Colors.blue,
                          strokeWidth: 2)
                    ],
                  )
              ],
            ),
          ),
          Positioned(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: MediaQuery.of(context).padding.left + 10,
                  right: MediaQuery.of(context).padding.left + 10,
                  bottom: MediaQuery.of(context).padding.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.73,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsApp.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorsApp.black025,
                                        spreadRadius: 0,
                                        blurRadius: 12,
                                        offset: const Offset(
                                            0, 4), // changes position of shadow
                                      ),
                                    ]),
                                child: _activePoligon
                                    ? TopBarActivePolygon(
                                        onPressedSaveArea: _handlePressSaveArea,
                                        isActiveBtn: _activeSaveArea,
                                        onPressDesativeArea:
                                            _handlePressDisableSaveArea,
                                      )
                                    : TopBarNotActivePolygon(_key)),
                            IconButton(
                              iconSize: 52,
                              onPressed: _handleVisibleTypeMap,
                              icon: SvgPicture.asset(
                                "assets/icons/layer.svg",
                                width: 50,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: !_isVisibleTypeMaps,
                          child: IconButton(
                            iconSize: 52,
                            onPressed: _getLocationUser,
                            icon: SvgPicture.asset(
                              "assets/icons/user_location.svg",
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isVisibleTypeMaps,
                          child: IconButton(
                            iconSize: 52,
                            onPressed: () => print("cliquei no resize"),
                            icon: SvgPicture.asset(
                              "assets/icons/resize.svg",
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _isVisibleTypeMaps,
                          child: SizedBox(
                            width: 123,
                            child: Card(
                              child: Column(
                                children: [
                                  ElevatedButtonIconWithText(
                                      handlePressButton: () {
                                        setState(() {
                                          _typeMapSelected = _typeMap[0];
                                        });
                                      },
                                      svgIcon: "assets/icons/map_default.svg",
                                      titleButton: "Padrão"),
                                  ElevatedButtonIconWithText(
                                      handlePressButton: () {
                                        setState(() {
                                          _typeMapSelected = _typeMap[2];
                                        });
                                      },
                                      svgIcon: "assets/icons/map_satellite.svg",
                                      titleButton: "Satéllite"),
                                  ElevatedButtonIconWithText(
                                      handlePressButton: () {
                                        setState(() {
                                          _typeMapSelected = _typeMap[1];
                                        });
                                      },
                                      svgIcon: "assets/icons/map_terrain.svg",
                                      titleButton: "Terreno"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _activePoligon
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                                color: ColorsApp.white),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ..._featureClicked
                                      .map((e) => IconButton(
                                          onPressed: () =>
                                              _handleFeatureClicked(e.id),
                                          icon: SvgPicture.asset(
                                            e.iconPath,
                                            height: 23,
                                            width: 23,
                                          )))
                                      .toList()
                                ],
                              ),
                            ),
                          ),
                        )
                      : BarButtonFeatures(
                          features: _features,
                          widthCard: 271,
                          handleClickedFeature: _handleFeature,
                        )
                ],
              ),
            ),
          ),
        ]));
  }
}
//satelite  url templates https://api.mapbox.com/styles/v1/kenjimaeda/clhj1egsu02u801pa8yd48xcy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg
//terreno 'https://api.mapbox.com/styles/v1/kenjimaeda/clhib3i6o02tm01p466le2wa1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
// default'https://api.mapbox.com/styles/v1/kenjimaeda/clhnjjmrg039d01pa3bz482gg/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg'
