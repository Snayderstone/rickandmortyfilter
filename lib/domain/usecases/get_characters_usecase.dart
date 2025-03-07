import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

class GetCharactersUseCase {
  final CharacterRepository repository;

  GetCharactersUseCase(this.repository);

  Future<Map<String, dynamic>> execute({String? url}) async {
    return await repository.fetchCharacters(url: url);
  }

  List<CharacterModel> filterCharacters({
    required List<CharacterModel> characters,
    required String query,
    required String status,
    required String gender,
  }) {
    return characters.where((character) {
      // Apply name filter
      final nameMatches = character.name.toLowerCase().contains(
        query.toLowerCase(),
      );

      // Apply status filter
      final statusMatches = status == 'All' || character.status == status;

      // Apply gender filter
      final genderMatches = gender == 'All' || character.gender == gender;

      return nameMatches && statusMatches && genderMatches;
    }).toList();
  }
}
