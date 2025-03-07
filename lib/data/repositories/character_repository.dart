import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterRepository {
  final String _baseUrl = 'https://rickandmortyapi.com/api/character';

  Future<Map<String, dynamic>> fetchCharacters({String? url}) async {
    final response = await http.get(Uri.parse(url ?? _baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      return {
        'characters':
            results.map((json) => CharacterModel.fromJson(json)).toList(),
        'nextPageUrl': data['info']['next'],
      };
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
