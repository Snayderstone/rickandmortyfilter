import 'package:flutter/material.dart';
import 'presentation/pages/characters_page.dart';

void main() {
  runApp(const RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  const RickAndMortyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty Characters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF97CE4C),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CharactersPage(),
    );
  }
}
