import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gherass/widgets/appBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../theme/styles.dart';

const String kGoogleApiKey = 'AIzaSyBHtFyZQEuNWSvSfTXsx7NeYZY2GGTCLVQ';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  bool _mapReady = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDisabledDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    _goToLocation(position.latitude, position.longitude);
  }

  void _goToLocation(double lat, double lng) {
    final pos = LatLng(lat, lng);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
    setState(() {
      _pickedLocation = pos;
    });
  }

  Future<void> _searchPlace(String place) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(place)}&key=$kGoogleApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['results'] != null && jsonData['results'].length > 0) {
        final location = jsonData['results'][0]['geometry']['location'];
        _goToLocation(location['lat'], location['lng']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Place not found")),
        );
      }
    } else {
      throw Exception('Failed to load place data');
    }
  }

  void _showLocationDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Disabled"),
        content: Text("Please enable location services in settings."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Permission Denied"),
        content: Text("Location permission is required to pick location."),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Pick Location", showBackButton: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(20.5937, 78.9629),
              zoom: 5,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _mapReady = true;
              _initLocation();
            },
            onTap: (latLng) {
              setState(() {
                _pickedLocation = latLng;
              });
            },
            markers: _pickedLocation != null
                ? {
              Marker(
                markerId: MarkerId("picked"),
                position: _pickedLocation!,
              ),
            }
                : {},
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _searchPlace,
                      decoration: InputDecoration(
                        hintText: "Search place...",
                        hintStyle: Styles.regularTextStyle(Colors.grey, 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () => _searchPlace(_searchController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "location",
            onPressed: _initLocation,
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: "confirm",
            backgroundColor: Colors.green,
            onPressed: () {
              if (_pickedLocation != null) {
                Navigator.pop(context, _pickedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Please select a location.")),
                );
              }
            },
            child: Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
