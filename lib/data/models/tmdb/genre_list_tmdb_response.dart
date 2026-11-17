class GenreListTMDbResponse {
  final List<GenreTMDbResponse> genres;

  GenreListTMDbResponse({
    required this.genres,
  });

  factory GenreListTMDbResponse.fromJson(Map<String, dynamic> json) =>
      GenreListTMDbResponse(
        genres: List<GenreTMDbResponse>.from(
          (json['genres'] ?? const [])
              .map((x) => GenreTMDbResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        'genres': List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}

class GenreTMDbResponse {
  final int id;
  final String name;

  GenreTMDbResponse({
    required this.id,
    required this.name,
  });

  factory GenreTMDbResponse.fromJson(Map<String, dynamic> json) =>
      GenreTMDbResponse(
        id: json['id'],
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
