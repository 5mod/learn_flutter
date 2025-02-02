import 'package:dartz/dartz.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/domain/entities/genre.dart';
import 'package:learn_flutter/domain/repositories/genre_repository.dart';

class GetGenresUseCase {
  final GenreRepository repository;

  GetGenresUseCase(this.repository);

  Future<Either<Failure, List<Genre>>> execute() async {
    return await repository.getGenres();
  }
}

class GetGenreUseCase {
  final GenreRepository repository;

  GetGenreUseCase(this.repository);

  Future<Either<Failure, Genre>> execute(int id) async {
    return await repository.getGenre(id);
  }
}

class CreateGenreUseCase {
  final GenreRepository repository;

  CreateGenreUseCase(this.repository);

  Future<Either<Failure, Genre>> execute({
    required String name,
    required String description,
  }) async {
    return await repository.createGenre(
      name: name,
      description: description,
    );
  }
}

class UpdateGenreUseCase {
  final GenreRepository repository;

  UpdateGenreUseCase(this.repository);

  Future<Either<Failure, Genre>> execute({
    required int id,
    required String name,
    required String description,
  }) async {
    return await repository.updateGenre(
      id: id,
      name: name,
      description: description,
    );
  }
}

class DeleteGenreUseCase {
  final GenreRepository repository;

  DeleteGenreUseCase(this.repository);

  Future<Either<Failure, void>> execute(int id) async {
    return await repository.deleteGenre(id);
  }
} 