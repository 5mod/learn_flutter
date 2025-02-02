import 'package:dartz/dartz.dart';
import 'package:learn_flutter/core/constants/api_endpoints.dart';
import 'package:learn_flutter/core/database/database_helper.dart';
import 'package:learn_flutter/core/errors/failures.dart';
import 'package:learn_flutter/core/network/dio_client.dart';
import 'package:learn_flutter/data/models/genre_model.dart';
import 'package:learn_flutter/domain/entities/genre.dart';
import 'package:learn_flutter/domain/repositories/genre_repository.dart';

class GenreRepositoryImpl implements GenreRepository {
  final DioClient dioClient;
  final DatabaseHelper dbHelper;

  GenreRepositoryImpl(this.dioClient, this.dbHelper);

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      // Try to sync with server first
      await syncWithServer();
      
      // Get from API
      final response = await dioClient.instance.get(ApiEndpoints.genre);
      final List<dynamic> genresJson = response.data['data'];
      final genres = genresJson.map((json) => GenreModel.fromJson(json)).toList();
      
      // Update local DB
      await dbHelper.clearTable();
      for (var genre in genres) {
        await dbHelper.insertGenre(genre);
      }
      
      return Right(genres);
    } catch (e) {
      // If API fails, get from local DB
      try {
        final localGenres = await dbHelper.getGenres();
        return Right(localGenres);
      } catch (dbError) {
        return Left(ServerFailure(message: dbError.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, Genre>> getGenre(int id) async {
    try {
      final response =
          await dioClient.instance.get('${ApiEndpoints.genre}/$id');
      final genre = GenreModel.fromJson(response.data['data']);
      return Right(genre);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Genre>> createGenre({
    required String name,
    required String description,
  }) async {
    try {
      // Try to create online
      final response = await dioClient.instance.post(
        ApiEndpoints.genre,
        data: {
          'name': name,
          'description': description,
        },
      );
      final genre = GenreModel.fromJson(response.data['data']);
      await dbHelper.insertGenre(genre);
      return Right(genre);
    } catch (e) {
      // If offline, save locally
      final genre = GenreModel(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        slug: name.toLowerCase().replaceAll(' ', '-'),
        description: description,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        animeCount: 0,
      );
      await dbHelper.insertGenre(genre);
      return Right(genre);
    }
  }

  @override
  Future<Either<Failure, Genre>> updateGenre({
    required int id,
    required String name,
    required String description,
  }) async {
    try {
      // Try to update online
      final response = await dioClient.instance.put(
        '${ApiEndpoints.genre}/$id',
        data: {
          'name': name,
          'description': description,
        },
      );
      final genre = GenreModel.fromJson(response.data['data']);
      await dbHelper.updateGenre(genre);
      return Right(genre);
    } catch (e) {
      // If offline, update locally
      final genre = GenreModel(
        id: id,
        name: name,
        slug: name.toLowerCase().replaceAll(' ', '-'),
        description: description,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        animeCount: 0,
      );
      await dbHelper.updateGenre(genre);
      return Right(genre);
    }
  }

  @override
  Future<Either<Failure, void>> deleteGenre(int id) async {
    try {
      // Try to delete online
      await dioClient.instance.delete('${ApiEndpoints.genre}/$id');
      await dbHelper.deleteGenre(id);
      return const Right(null);
    } catch (e) {
      // If offline, delete locally
      await dbHelper.deleteGenre(id);
      return const Right(null);
    }
  }

  Future<void> syncWithServer() async {
    try {
      // Get all unsynced genres
      final unsyncedGenres = await dbHelper.getUnsyncedGenres();
      
      for (var genre in unsyncedGenres) {
        try {
          // Try to sync each genre with server
          final response = await dioClient.instance.post(
            ApiEndpoints.genre,
            data: {
              'name': genre.name,
              'description': genre.description,
            },
          );
          
          // If successful, mark as synced
          if (response.statusCode == 200 || response.statusCode == 201) {
            await dbHelper.markAsSynced(genre.id);
          }
        } catch (e) {
          print('Error syncing genre ${genre.id}: $e');
          // Continue with next genre even if this one fails
          continue;
        }
      }

      // After syncing changes, get fresh data from server
      final response = await dioClient.instance.get(ApiEndpoints.genre);
      final List<dynamic> genresJson = response.data['data'];
      final genres = genresJson.map((json) => GenreModel.fromJson(json)).toList();
      
      // Clear local DB and save fresh data
      await dbHelper.clearTable();
      for (var genre in genres) {
        await dbHelper.insertGenre(genre);
      }
    } catch (e) {
      print('Error during sync: $e');
    }
  }
}
