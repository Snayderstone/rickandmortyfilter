class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String image;
  final String url;
  final OriginModel origin;
  final LocationModel location;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.image,
    required this.url,
    required this.origin,
    required this.location,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      image: json['image'],
      url: json['url'],
      origin: OriginModel.fromJson(json['origin']),
      location: LocationModel.fromJson(json['location']),
    );
  }
}

class OriginModel {
  final String name;
  final String url;

  OriginModel({required this.name, required this.url});

  factory OriginModel.fromJson(Map<String, dynamic> json) {
    return OriginModel(name: json['name'], url: json['url']);
  }
}

class LocationModel {
  final String name;
  final String url;

  LocationModel({required this.name, required this.url});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(name: json['name'], url: json['url']);
  }
}
