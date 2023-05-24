import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_line_editor/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:trivato/colors/ColorsApp.dart';
import 'package:trivato/widget/BarButtonFeatures.dart';
import 'package:trivato/widget/DrawerNavigation.dart';
import 'package:trivato/widget/ElevatedButtonIconWithText.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final MapController _mapController = MapController();
  final LatLng _lastLatitudeAndLongitude = LatLng(0.0, 0.0);
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

  handlePolygon(_, LatLng position) {
    setState(() {
      _polyEditor.add(_firstPolygon.points, position);
    });
  }

  _handleEditFeature() {
    print("edit");
  }

  _handleDeleteFeature() {
    setState(() {
      _polyEditor.points.removeRange(0, _polyEditor.points.length - 1);
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
      addClosePathMarker: true,
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
      setState(() => _mapController.move(
          LatLng(position.latitude, position.longitude), 17));
    }).catchError((e) {
      debugPrint(e);
    });
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      key: _key,
      drawer: const DrawerNavigation(),
      body: Stack(children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(-18.1778564, -54.8739394),
                zoom: 4,
                onTap: _activePoligon ? handlePolygon : null,
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
                DragMarkers(markers: _polyEditor.edit(),),


              ],
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
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 9),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(
                                                            text: "LAT",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              height: 1.5,
                                                              color: ColorsApp
                                                                  .grayBlack,
                                                            ),
                                                            children: [
                                                          TextSpan(
                                                              text:
                                                                  " ${_lastLatitudeAndLongitude.latitude}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                height: 1.5,
                                                                color: ColorsApp
                                                                    .grayBlack,
                                                              ))
                                                        ])),
                                                    RichText(
                                                        text: TextSpan(
                                                            text: "LNG",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              height: 1.5,
                                                              color: ColorsApp
                                                                  .grayBlack,
                                                            ),
                                                            children: [
                                                          TextSpan(
                                                              text:
                                                                  " ${_lastLatitudeAndLongitude.longitude}",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 14,
                                                                height: 1.5,
                                                                color: ColorsApp
                                                                    .grayBlack,
                                                              ))
                                                        ])),
                                                  ]),
                                            ),
                                            SizedBox(
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.save),
                                                  Icon(Icons.clear),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : TextField(
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
                                                                  ColorsApp
                                                                      .black,
                                                                  BlendMode
                                                                      .srcIn),
                                                          width: 28,
                                                          height: 28,
                                                          fit: BoxFit.contain),
                                                      onPressed: () => _key
                                                          .currentState
                                                          ?.openDrawer());
                                                })),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 14)),
                                      ),
                              ),
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
                                        svgIcon:
                                            "assets/icons/map_satellite.svg",
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
          ])
    );
  }
}
//satelite  url templates https://api.mapbox.com/styles/v1/kenjimaeda/clhj1egsu02u801pa8yd48xcy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg
//terreno 'https://api.mapbox.com/styles/v1/kenjimaeda/clhib3i6o02tm01p466le2wa1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
// default'https://api.mapbox.com/styles/v1/kenjimaeda/clhnjjmrg039d01pa3bz482gg/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg'

_handleFeatureClicked(int id) {}
