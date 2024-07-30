import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plas_track/Utils/constants.dart';
import 'package:plas_track/Widgets/custom_text.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: SideBar(),
      appBar: AppBar(
        title: const CustomText(
          value: "View Flags in Map",
          color: white,
        ),
        backgroundColor: black,
        iconTheme: const IconThemeData(color: white),
      ),
      body: FlutterMap(
          options: const MapOptions(
              initialCenter: LatLng(12.9775876, 80.2133303),
              initialZoom: 12,
              interactionOptions:
                  InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom)),
          children: [
            openStreetMaptileLater,
            const MarkerLayer(markers: [
              Marker(
                  point: LatLng(12.9775876, 80.2133303),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 50,
                    color: red,
                  )),
              Marker(
                  point: LatLng(12.9830269, 80.2594001),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 60,
                    color: red,
                  )),
              Marker(
                  point: LatLng(12.9880288, 80.20471330000001),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 60,
                    color: red,
                  )),
              Marker(
                  point: LatLng(12.9737143, 80.21829749999999),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 60,
                    color: red,
                  )),
              Marker(
                  point: LatLng(12.8685685, 80.2169369),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 50,
                    color: red,
                  )),
            ]),
          ]),
    );
  }
}

TileLayer get openStreetMaptileLater => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );