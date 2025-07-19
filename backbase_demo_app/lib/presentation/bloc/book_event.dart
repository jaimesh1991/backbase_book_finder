part of 'book_bloc.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchBooks extends BookEvent {
  final String query;
  final int page;

  SearchBooks(this.query, {this.page = 1});

  @override
  List<Object?> get props => [query, page];
}
