import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String title;
  final String author;
  final String coverUrl;
  final String key;

  const BookEntity({
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.key,
  });

  @override
  List<Object?> get props => [title, author, coverUrl, key];

  factory BookEntity.fromMap(Map<String, dynamic> map) {
    return BookEntity(
      title: map['title'] as String,
      author: map['author'] as String,
      coverUrl: map['coverUrl'] as String,
      key: map['key'] as String,
    );
  }
}
