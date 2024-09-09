import 'package:favourite_placess/main.dart';
import 'package:favourite_placess/model/places.dart';
import 'package:favourite_placess/providers/user_place.dart';
import 'package:favourite_placess/widgets/details.dart';
import 'package:favourite_placess/widgets/place_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerStatefulWidget {
  const PlacesList({super.key});

  @override
  ConsumerState<PlacesList> createState() => _PlacesListState();
}

class _PlacesListState extends ConsumerState<PlacesList> {
  late Future<void> _loadplaces;
  @override
  void initState() {
    super.initState();
    _loadplaces=ref.read(userplacenotifier.notifier).loaddatabse();
  }
  void addplace() {
    Navigator.of(context).push<Places>(
        MaterialPageRoute(builder: ((context) => const PlaceInput())));
  }

  @override
  Widget build(BuildContext context) {
    final userplace = ref.watch(userplacenotifier);
    Widget content = Center(
        child: Text(
      "no places add yet.",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: colorsceme.onBackground),
    ));
    if (userplace.isNotEmpty) {
      content =FutureBuilder(future: _loadplaces, builder: (context,snapshot)=>snapshot.connectionState==ConnectionState.waiting?const CircularProgressIndicator():ListView.builder(
        itemCount: userplace.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(userplace[index].image),
              ),
              title: Text(userplace[index].title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: colorsceme.onBackground)),
                      subtitle: Text(userplace[index].placelocation.address,style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: colorsceme.onBackground)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Detailsplace(
                          detailplace: userplace[index],
                        )));
              },
            ),
          );
        },
      )); 
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Favourite Place"), actions: [
        IconButton(onPressed: addplace, icon: const Icon(Icons.add))
      ]),
      body: content,
    );
  }
}
