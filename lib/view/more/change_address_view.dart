import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  GoogleMapController? _controller;

  final locations = const [
    LatLng(37.42796133580664, -122.085749655962),
  ];

  late List<MarkerData> _customMarkers;

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.42796133580664, -122.085749655962),
      // tilt: 59.440717697143555,
      zoom: 14.151926040649414);

  @override
  void initState() {
    super.initState();
    _customMarkers = [
      MarkerData(
          marker:
              Marker(markerId: const MarkerId('id-1'), position: locations[0]),
          child: _customMarker('Everywhere\nis a Widgets', Colors.blue)),
    ];
  }

  _customMarker(String symbol, Color color) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Image.asset(
            'assets/img/map_pin.png',
            width: 35,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
        ),
        centerTitle: false,
        title: Text(
          "Change Address",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: CustomGoogleMapMarkerBuilder(
        //screenshotDelay: const Duration(seconds: 4),
        customMarkers: _customMarkers,
        builder: (BuildContext context, Set<Marker>? markers) {
          if (markers == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kLake,
            compassEnabled: false,
            gestureRecognizers: Set()
              ..add(Factory<PanGestureRecognizer>(
                () => PanGestureRecognizer(),
              )),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
          child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric( vertical: 15 , horizontal: 25),
            child: RoundTextfield(
              hintText: "Search Address",
              left: Icon(Icons.search, color: TColor.primaryText),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 25),
            child: Row(children: [

              Image.asset('assets/img/fav_icon.png', width: 35, height: 35 ), 

              const SizedBox(width: 8,),

              Expanded(
                child: Text(
                  "Choose a saved place",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),

              Image.asset('assets/img/btn_next.png', width: 15, height: 15, color: TColor.primaryText, )

            ]),
          ),


        ],
      ))),
    );
  }
}
