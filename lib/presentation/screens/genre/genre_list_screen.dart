import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_flutter/presentation/controllers/genre_controller.dart';
import 'package:learn_flutter/domain/entities/genre.dart';

class GenreListScreen extends StatelessWidget {
  const GenreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GenreController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Genres'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, controller),
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error != null) {
            return Center(child: Text(controller.error!));
          }

          if (controller.genres.isEmpty) {
            return const Center(child: Text('No genres found'));
          }

          return ListView.builder(
            itemCount: controller.genres.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final genre = controller.genres[index];
              return GenreCard(
                genre: genre,
                onEdit: () => _showEditDialog(context, controller, genre),
                onDelete: () => _showDeleteDialog(context, controller, genre),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, GenreController controller) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Genre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createGenre(
                name: nameController.text,
                description: descriptionController.text,
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, GenreController controller, Genre genre) {
    final nameController = TextEditingController(text: genre.name);
    final descriptionController = TextEditingController(text: genre.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Genre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateGenre(
                id: genre.id,
                name: nameController.text,
                description: descriptionController.text,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, GenreController controller, Genre genre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Genre'),
        content: Text('Are you sure you want to delete ${genre.name}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteGenre(genre.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final Genre genre;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GenreCard({
    super.key,
    required this.genre,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(genre.name),
        subtitle: Text(genre.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
} 