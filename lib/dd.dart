import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController mapController;
  Location location = Location();
  LocationData? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        _currentLocation = userLocation;
        _markers.add(
          Marker(
            markerId: MarkerId('myLocation'),
            position: LatLng(userLocation.latitude!, userLocation.longitude!),
            infoWindow: InfoWindow(title: 'My Location'),
          ),
        );
      });
      print(
          "${LatLng(userLocation.latitude!, userLocation.longitude!)}///////////////////////////////////////////////////////////////////////////////");
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentLocation!.latitude!, _currentLocation!.longitude!),
                zoom: 15,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }
}
