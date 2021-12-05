import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';


class MapSample extends StatefulWidget {
  String lat;
  String long;
  String id;
  MapSample(this.lat,this.long,this.id);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();


  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(41,41),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );


  Set<Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(double.tryParse(widget.lat), double.tryParse(widget.long)),
      zoom: 14.4746,
    );

    _markers.add(Marker(
      markerId: MarkerId("konum"),
      position: LatLng(double.tryParse(widget.lat), double.tryParse(widget.long)),
      infoWindow: InfoWindow(
        title: 'Kurye id',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));


    return new Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}