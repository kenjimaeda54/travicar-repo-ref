import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_line_editor/dragmarker.dart';
import 'package:flutter_map_line_editor/polyeditor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:indexed/indexed.dart';
import 'package:latlong2/latlong.dart';
import 'package:trivato/colors/ColorsApp.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final _mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut);
  LatLng? _currentPosition;
  late PolyEditor polyEditor;


  List<Polygon> polygons = [];

  var firstPolygon = Polygon(
      color: const Color.fromRGBO(144, 238, 144, 0.5),
      isFilled: true,
      points: [],
      isDotted: true);

  handlePolygon(TapPosition tap, LatLng position) {
    setState(() {
      polyEditor.add(firstPolygon.points, position);
    });
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

    polyEditor = PolyEditor(
      addClosePathMarker: true,
      points: firstPolygon.points,
      pointIcon: const Icon(Icons.circle,
          size: 18, color: Color.fromRGBO(255, 255, 255, 0.7)),
      intermediateIcon: const Icon(Icons.circle,
          size: 15, color: Color.fromRGBO(255, 255, 255, 0.7)),
      callbackRefresh: () => {setState(() {})},
    );

    polygons.add(firstPolygon);
  }

  // handleMapReady() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //     setState(() => _mapController.move(
  //         LatLng(position.latitude, position.longitude), 17));
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(-18.1778564, -54.8739394),
            zoom: 4,
            onTap: handlePolygon,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/kenjimaeda/clhj1egsu02u801pa8yd48xcy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
              additionalOptions: const {
                'accessToken':
                    'pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
              },
            ),
            PolygonLayer(polygons: polygons),
            DragMarkers(markers: polyEditor.edit()),
          ],
        ),
        Positioned(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top + 10,
                horizontal: 20),
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
                        child: TextField(
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
                              suffixIcon: const Icon(Icons.search, size: 30),
                              suffixIconColor: ColorsApp.black,
                              prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SvgPicture.asset(
                                      "assets/icons/menu.svg",
                                      colorFilter: ColorFilter.mode(
                                          ColorsApp.black, BlendMode.srcIn),
                                      width: 28,
                                      height: 28,
                                      fit: BoxFit.contain)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 14)),
                        ),
                      ),
                      IconButton(
                        iconSize: 52,
                        onPressed: () => print("cliquei no layer"),
                        icon: SvgPicture.asset(
                          "assets/icons/layer.svg",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ],),
                IconButton(
                  iconSize: 52,
                  onPressed:  () => print("cliquei no user location"),
                  icon: SvgPicture.asset(
                    "assets/icons/user_location.svg",
                    width: 50,
                    height: 50,
                  ),
                ),
                IconButton(
                  iconSize: 52,
                  onPressed:  () => print("cliquei no resize"),
                  icon: SvgPicture.asset(
                    "assets/icons/resize.svg",
                    width: 50,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
//street  url templates https://api.mapbox.com/styles/v1/kenjimaeda/clhj1egsu02u801pa8yd48xcy/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg
//default 'https://api.mapbox.com/styles/v1/kenjimaeda/clhib3i6o02tm01p466le2wa1/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoia2VuamltYWVkYSIsImEiOiJjbGdoYWoxZHIwanYwM2dvMm92Mno2M2JwIn0.BOijx8XvFrrqZwwBC1Uizg',
