import 'dart:convert';

import 'package:favourite_placess/main.dart';
import 'package:favourite_placess/model/places.dart';
import 'package:favourite_placess/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key,required this.onselectedlocation});
final void Function(PlaceHolderLocation selectedlocation) onselectedlocation;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceHolderLocation? preventlocation;
  var _isgettinglocation = false;
  String get locationimage{
    if (preventlocation == null) {
      return'';
    }
    final lat=preventlocation!.lattitude;
    final lng= preventlocation!.lontitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=YOUR_API_KEY';
  }
  void savelocation(double lattidude , double longtude)async{
     final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lattidude,$longtude&key=YOUR_API_KEY');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final address = resdata['results'][0]['formatted_address'];
    setState(() {
      preventlocation =
          PlaceHolderLocation(lattitude: lattidude, lontitude: longtude, address: address);

      _isgettinglocation = false;
    });
  }
  void _getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isgettinglocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
   
    widget.onselectedlocation(preventlocation!);
  }
  void savepicedon()async{
  final picedlocation= await Navigator.of(context).push<LatLng>(MaterialPageRoute(builder: (ctx)=>const MapScreen()));
  if (picedlocation ==null) {
    return;
  }
  savelocation(picedlocation.latitude, picedlocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget preventcontent = Text(
      "No location chosen",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: colorsceme.onSurface),
      textAlign: TextAlign.center,
    );
    if (preventlocation !=null) {
      preventcontent=Image.network(locationimage,fit: BoxFit.cover,width: double.infinity,height: double.infinity,);
    }
    if (_isgettinglocation) {
      preventcontent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          height: 170,
          width: double.infinity,
          child: preventcontent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getcurrentlocation,
                icon: const Icon(Icons.location_pin),
                label: const Text("Get your current location")),
            TextButton.icon(
                onPressed: savepicedon,
                icon: const Icon(Icons.map),
                label: const Text("Open your map"))
          ],
        )
      ],
    );
  }
}
