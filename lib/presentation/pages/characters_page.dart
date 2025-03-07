import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../widgets/character_card.dart';
import '../widgets/character_details.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late GetCharactersUseCase _getCharactersUseCase;
  List<CharacterModel> characters = [];
  List<CharacterModel> filteredCharacters = [];
  bool isLoading = true;
  String? nextPageUrl;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';
  String _selectedGender = 'All';

  @override
  void initState() {
    super.initState();
    _getCharactersUseCase = GetCharactersUseCase(CharacterRepository());
    fetchCharacters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchCharacters({String? url}) async {
    setState(() {
      if (url == null) {
        isLoading = true;
      }
    });

    try {
      final result = await _getCharactersUseCase.execute(url: url);
      final newCharacters = result['characters'] as List<CharacterModel>;

      setState(() {
        if (url == null) {
          characters = newCharacters;
          filteredCharacters = List.from(characters);
        } else {
          characters.addAll(newCharacters);
          filteredCharacters = List.from(characters);
        }

        nextPageUrl = result['nextPageUrl'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to load characters: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  void _filterCharacters() {
    setState(() {
      filteredCharacters = _getCharactersUseCase.filterCharacters(
        characters: characters,
        query: _searchController.text,
        status: _selectedStatus,
        gender: _selectedGender,
      );
    });
  }

  void _showCharacterDetails(CharacterModel character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder:
                (_, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: CharacterDetails(character: character),
                ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty Characters'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search character',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterCharacters();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => _filterCharacters(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedStatus,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Alive', child: Text('Alive')),
                      DropdownMenuItem(value: 'Dead', child: Text('Dead')),
                      DropdownMenuItem(
                        value: 'unknown',
                        child: Text('Unknown'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                        _filterCharacters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All')),
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                      DropdownMenuItem(
                        value: 'Genderless',
                        child: Text('Genderless'),
                      ),
                      DropdownMenuItem(
                        value: 'unknown',
                        child: Text('Unknown'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                        _filterCharacters();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                isLoading && characters.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredCharacters.isEmpty
                    ? const Center(child: Text('No characters found'))
                    : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            nextPageUrl != null &&
                            !isLoading) {
                          fetchCharacters(url: nextPageUrl);
                        }
                        return false;
                      },
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount:
                            filteredCharacters.length +
                            (nextPageUrl != null ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == filteredCharacters.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final character = filteredCharacters[index];
                          return CharacterCard(
                            character: character,
                            onTap: () => _showCharacterDetails(character),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
