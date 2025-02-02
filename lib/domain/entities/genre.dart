class Genre {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int animeCount;

  Genre({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.animeCount,
  });
} 