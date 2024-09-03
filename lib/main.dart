
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  runApp(const GoogleMaps());
}

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Position? currentPosition;
  var lat;
  var long;
  var destinationLat;
  var destinationLong;
  late GoogleMapController _googleMapController;

  @override
  void initState() {

    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Google Map'),
          backgroundColor: Colors.lightGreen,
        ),
        body:  GoogleMap(
          initialCameraPosition: CameraPosition(

            target: LatLng(lat,long),
            zoom:11,
          ),
          onMapCreated: (GoogleMapController controller){
            _googleMapController = controller;
          },
          zoomControlsEnabled: true,
          myLocationEnabled: true,


          onTap: (LatLng latlng){

            destinationLat = latlng?.latitude;
            destinationLong = latlng?.longitude;

             <Polyline>{
              Polyline(
                  polylineId: PolylineId('Sample'),
                  color: Colors.pinkAccent,
                  points: [
                    LatLng(lat, long),
                    LatLng(destinationLat, destinationLong),


                  ]

              )
            };

            setState(() {});

          },

        ),

    );
  }

  Future<void> _getCurrentLocation() async{

    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.always || permission == LocationPermission.whileInUse){

        final bool isEnable = await Geolocator.isLocationServiceEnabled();

        if(isEnable ){

          currentPosition = await Geolocator.getCurrentPosition();

           lat = currentPosition?.latitude;
           long = currentPosition?.longitude;

          if(mounted){
            setState(() {});
          }


        }else{

          Geolocator.openLocationSettings();
        }


    }else{


      if(permission == LocationPermission.deniedForever){

        Geolocator.openAppSettings();
        return;
      }

      LocationPermission requestedPermission = await Geolocator.requestPermission();
      if(requestedPermission == LocationPermission.always || requestedPermission == LocationPermission.whileInUse){

        _getCurrentLocation();

      }



    }


  }
}
