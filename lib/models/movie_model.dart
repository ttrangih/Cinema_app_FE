// lib/models/movie_model.dart
class MovieModel {
  final int id;
  final String title;
  final String? description;
  final String? posterUrl;
  final String? trailerUrl;
  final int? duration;
  final String? releaseDate;
  final String? ageRating;
  final String? genre;

  MovieModel({
    required this.id,
    required this.title,
    this.description,
    this.posterUrl,
    this.trailerUrl,
    this.duration,
    this.releaseDate,
    this.ageRating,
    this.genre,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    id: json['id'] ?? 0,
    title: json['title'] ?? '',
    description: json['description'] ?? '',

    // Backend có thể trả posterUrl hoặc posterurl
    posterUrl: json['posterUrl'] ?? json['posterurl'] ?? '',

    // Backend có thể trả trailerUrl hoặc trailerurl
    trailerUrl: json['trailerUrl'] ?? json['trailerurl'] ?? '',

    // Backend đang trả durationminutes
    duration: json['duration'] ?? json['durationMinutes'] ?? json['durationminutes'],

    // Backend đang trả releasedate
    releaseDate: json['releaseDate'] ?? json['releasedate'] ?? '',

    // Backend đang trả agerating
    ageRating: json['ageRating'] ?? json['agerating'] ?? '',

    genre: json['genre'] ?? '',
  );
}