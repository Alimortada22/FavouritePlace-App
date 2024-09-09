import 'package:favourite_placess/main.dart';
import 'package:favourite_placess/model/places.dart';
import 'package:favourite_placess/screens/map_screen.dart';
import 'package:flutter/material.dart';

class Detailsplace extends StatelessWidget {
  const Detailsplace({super.key, required this.detailplace});
  final Places detailplace;
  String get locationimage {
    final lat = detailplace.placelocation.lattitude;
    final lng = detailplace.placelocation.lontitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=YOUR_API_KEY';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detailplace.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: colorsceme.onBackground)),
      ),
      body: Stack(
        children: [
          Image.file(
            detailplace.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                                location: detailplace.placelocation,
                                isSelecting: false,
                              )));
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationimage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black45],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Text(detailplace.placelocation.address),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
