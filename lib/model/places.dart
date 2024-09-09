import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceHolderLocation {
  const PlaceHolderLocation(
      {required this.lattitude,
      required this.lontitude,
      required this.address});
  final double lattitude;
  final double lontitude;
  final String address;
}

class Places {
  Places({required this.title, required this.image,required this.placelocation, String? id}) : id = id ?? uuid.v4();
  String id;
  final String title;
  final File image;
  final PlaceHolderLocation placelocation;
}
