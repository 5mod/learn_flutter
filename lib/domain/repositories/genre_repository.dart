import 'package:dartz/dartz.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, Genre>> getGenre(int id);
  Future<Either<Failure, Genre>> createGenre({
    required String name,
    required String description,
  });
  Future<Either<Failure, Genre>> updateGenre({
    required int id,
    required String name,
    required String description,
  });
  Future<Either<Failure, void>> deleteGenre(int id);
} 