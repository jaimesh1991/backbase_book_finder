import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _rotation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveBook(BookEntity book) async {
    final repository = context.read<BookRepository>();
    await repository.saveBook(book);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Book saved locally!")));
  }

  @override
  Widget build(BuildContext context) {
    final BookEntity book = ModalRoute.of(context)!.settings.arguments as BookEntity;

    return Scaffold(
      appBar: AppBar(title: const Text("Book Details")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Center(
                child: RotationTransition(
                  turns: _rotation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: book.coverUrl.isNotEmpty
                        ? Image.network(
                      book.coverUrl,
                      height: 250,
                      width: 160,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.book, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                book.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Author: ${book.author}",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: () => _saveBook(book),
                  icon: const Icon(Icons.save),
                  label: const Text("Save Book"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
