import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../domain/entities/book_entity.dart';

class BookTile extends StatelessWidget {
  final BookEntity book;

  const BookTile({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        height: 70,
        child: book.coverUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: book.coverUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Icon(Icons.image, size: 40, color: Colors.grey),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image),
              )
            : const Icon(Icons.book, size: 40),
        /*book.coverUrl.isNotEmpty
            ? Image.network(
          book.coverUrl,
          fit: BoxFit.cover, // Ensures image fills the space
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image),
        )
            : const Icon(Icons.book, size: 40),*/
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: book);
      },
    );
  }
}
