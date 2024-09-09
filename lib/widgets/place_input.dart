import 'dart:io';

import 'package:favourite_placess/model/places.dart';
import 'package:favourite_placess/providers/user_place.dart';
import 'package:favourite_placess/widgets/input_image.dart';
import 'package:favourite_placess/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceInput extends ConsumerStatefulWidget {
  const PlaceInput({super.key});

  @override
  ConsumerState<PlaceInput> createState() => _PlaceInputState();
}

class _PlaceInputState extends ConsumerState<PlaceInput> {
  final formkey = GlobalKey<FormState>();
  String? title ;
  File? _selectedimage;
  PlaceHolderLocation? onselectedlocation;
  void save() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      if (title ==null||_selectedimage==null || onselectedlocation==null) {
        return;
      }
      ref.read(userplacenotifier.notifier).addplace(title!,_selectedimage!,onselectedlocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add new place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    label: Text("Title"),
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length > 50) {
                      return "Enter correct value!";
                    }
                    title = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                 InputImage(onpickimage:(image) {
                  _selectedimage=image;
                }, ),
                const SizedBox(height: 10,),
                 LocationInput(onselectedlocation: (selectedlocation) {
                  onselectedlocation=selectedlocation;
                },),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                    onPressed: save,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Place"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
