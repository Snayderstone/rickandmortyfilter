import 'package:flutter/material.dart';
import '../../data/models/character_model.dart';

class CharacterDetails extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetails({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  character.image,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              character.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        character.status == 'Alive'
                            ? Colors.green
                            : character.status == 'Dead'
                            ? Colors.red
                            : Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${character.status} - ${character.species}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoSection('Gender', character.gender),
            _buildInfoSection('Origin', character.origin.name),
            _buildInfoSection('Location', character.location.name),
            _buildInfoSection(
              'Type',
              character.type.isNotEmpty ? character.type : 'Unknown',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$title:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(content, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
