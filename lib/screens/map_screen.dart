import 'package:favourite_placess/model/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.location = const PlaceHolderLocation(
          lattitude: 37.422, lontitude: -122.084, address: ""),
      this.isSelecting = true});
  final PlaceHolderLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? "pick your location" : "Your location"),
        actions: [
          if (widget.isSelecting)
            IconButton(onPressed: () {
              Navigator.of(context).pop(_pickedlocation);
            }, icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
          onTap:!widget.isSelecting?null: (position) {
            setState(() {
              _pickedlocation = position;
            });
          },
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.location.lattitude, widget.location.lontitude)),
          markers: (_pickedlocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                      markerId: const MarkerId("m1"),
                      position: _pickedlocation ??
                          LatLng(widget.location.lattitude,
                              widget.location.lontitude)),
                }),
    );
  }
}
