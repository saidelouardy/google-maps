import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

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

        // Add the destination marker
        _markers.add(
          Marker(
            markerId: MarkerId('destination'),
            position: LatLng(37.416664160452804, -122.09759343966728),
            infoWindow: InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );

        // Calculate the polyline coordinates
        _getPolylineCoordinates(userLocation.latitude!, userLocation.longitude!,
            37.416664160452804, -122.09759343966728);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _getPolylineCoordinates(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyB-WebGyAzuKg90pKNomLYGFaCPTYw9AWw",
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(endLatitude, endLongitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {});
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
                zoom: 13,
              ),
              markers: _markers,
              polylines: {
                Polyline(
                  polylineId: PolylineId('polyline'),
                  color: Colors.blue,
                  points: polylineCoordinates,
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
    );
  }
}
