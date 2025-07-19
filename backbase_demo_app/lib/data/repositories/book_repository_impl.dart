import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';
import '../models/book_model.dart';
import '../datasources/book_local_datasource.dart';


class BookRepositoryImpl implements BookRepository {
  final Dio dio;
  final BookLocalDataSource localDataSource;

  BookRepositoryImpl(this.dio, [BookLocalDataSource? local])
      : localDataSource = local ?? BookLocalDataSource();

  @override
  Future<List<BookEntity>> searchBooks(String query, int page) async {
    // debugPrint("Params - {'q': $query, 'page': $page, 'limit': 15}");

    final response = await dio.get(
      'https://openlibrary.org/search.json',
      queryParameters: {'q': query, 'page': page, 'limit': 15},
    );

    final docs = response.data['docs'] as List;
    return docs.map((json) => BookModel.fromJson(json)).toList();
  }

  @override
  Future<void> saveBook(BookEntity book) async {
    await localDataSource.saveBook(book);
  }
}
