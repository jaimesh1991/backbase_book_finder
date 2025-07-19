import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  BookModel({
    required super.title,
    required super.author,
    required super.coverUrl,
    required super.key,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'] ?? '',
      author: (json['author_name'] as List?)?.first ?? 'Unknown',
      coverUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-M.jpg'
          : '',
      key: json['key'],
    );
  }
}
