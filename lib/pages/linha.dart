import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tcc_app/services/funcoes.dart' as funcoes;

class LinhaScreen extends StatefulWidget {
  final int id;

  LinhaScreen(this.id);
  
  @override
  _LinhaWidgetState createState() => _LinhaWidgetState();
}

class _LinhaWidgetState extends State<LinhaScreen> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition userLocation = CameraPosition(
    target: LatLng(-25.7529155, -53.0186067),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: 3)
        .listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());

      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17,
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: GoogleMap(
            compassEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: userLocation,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: (){
              funcoes.finalizarLinha(context, widget.id);
            },
            label: Text('FINALIZAR', style: TextStyle(fontSize: 25)),
            icon: Icon(FontAwesomeIcons.stopCircle, size: 35),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }
}
