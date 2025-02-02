import 'package:get/get.dart';
import 'package:learn_flutter/domain/entities/genre.dart';
import 'package:learn_flutter/domain/usecases/genre_usecases.dart';
import 'package:flutter/material.dart';

class GenreController extends GetxController {
  final GetGenresUseCase getGenresUseCase;
  final GetGenreUseCase getGenreUseCase;
  final CreateGenreUseCase createGenreUseCase;
  final UpdateGenreUseCase updateGenreUseCase;
  final DeleteGenreUseCase deleteGenreUseCase;

  final _genres = <Genre>[].obs;
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  final _selectedGenre = Rxn<Genre>();

  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  Genre? get selectedGenre => _selectedGenre.value;

  GenreController({
    required this.getGenresUseCase,
    required this.getGenreUseCase,
    required this.createGenreUseCase,
    required this.updateGenreUseCase,
    required this.deleteGenreUseCase,
  });

  @override
  void onReady() {
    super.onReady();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    _isLoading.value = true;
    _error.value = null;

    final result = await getGenresUseCase.execute();

    result.fold(
      (failure) => _error.value = failure.message,
      (genres) => _genres.value = genres,
    );

    _isLoading.value = false;
  }

  Future<void> createGenre({
    required String name,
    required String description,
  }) async {
    _isLoading.value = true;
    _error.value = null;

    final result = await createGenreUseCase.execute(
      name: name,
      description: description,
    );

    result.fold(
      (failure) {
        _error.value = failure.message;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      },
      (genre) {
        _genres.add(genre);
        Get.back(); // Close create dialog/screen
        Get.snackbar(
          'Success',
          'Genre created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      },
    );

    _isLoading.value = false;
  }

  Future<void> updateGenre({
    required int id,
    required String name,
    required String description,
  }) async {
    _isLoading.value = true;
    _error.value = null;

    final result = await updateGenreUseCase.execute(
      id: id,
      name: name,
      description: description,
    );

    result.fold(
      (failure) {
        _error.value = failure.message;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      },
      (genre) {
        final index = _genres.indexWhere((g) => g.id == id);
        if (index != -1) {
          _genres[index] = genre;
        }
        Get.back(); // Close edit dialog/screen
        Get.snackbar(
          'Success',
          'Genre updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      },
    );

    _isLoading.value = false;
  }

  Future<void> deleteGenre(int id) async {
    _isLoading.value = true;
    _error.value = null;

    final result = await deleteGenreUseCase.execute(id);

    result.fold(
      (failure) {
        _error.value = failure.message;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      },
      (_) {
        _genres.removeWhere((genre) => genre.id == id);
        Get.snackbar(
          'Success',
          'Genre deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      },
    );

    _isLoading.value = false;
  }

  void selectGenre(Genre genre) {
    _selectedGenre.value = genre;
  }
}
