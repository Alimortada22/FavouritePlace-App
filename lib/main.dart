import 'package:favourite_placess/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ProviderScope(child: MyApp(),));
}

final colorsceme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 102, 6, 246),
    background: const Color.fromARGB(255, 59, 47, 66),
    brightness: Brightness.dark);
final theme = ThemeData().copyWith(
    scaffoldBackgroundColor: colorsceme.background,
    colorScheme: colorsceme,
    textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
      bodySmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold),
      bodyMedium: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favourite Place',
      theme: theme,
      home: const Scaffold(
          
          body:  PlacesList()),
    );
  }
}
