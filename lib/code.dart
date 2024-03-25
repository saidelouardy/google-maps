import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location on Google Maps',
      debugShowCheckedModeBanner: false,
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController _controller;
  LatLng _initialCameraPosition = LatLng(0, 0);
  Set<Marker> _markers = {};

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId("user_location"),
            position: _initialCameraPosition,
          ),
        );
      });
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _initialCameraPosition,
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getCurrentLocation();
    print(
        "$_initialCameraPosition//////////////////////////////////////////////////");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition,
          zoom: 15,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: _markers,
      ),
    );
  }
}
