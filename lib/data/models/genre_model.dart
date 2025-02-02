import 'package:learn_flutter/domain/entities/genre.dart';

class GenreModel extends Genre {
  GenreModel({
    required int id,
    required String name,
    required String slug,
    required String description,
    required String createdAt,
    required String updatedAt,
    String? deletedAt,
    required int animeCount,
  }) : super(
          id: id,
          name: name,
          slug: slug,
          description: description,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deletedAt: deletedAt,
          animeCount: animeCount,
        );

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      animeCount: json['anime_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
} 