part of 'book_bloc.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState with EquatableMixin {
  final List<BookEntity> books;
  final bool isRefreshing;
  final bool hasMore;

  BookLoaded({
    required this.books,
    this.isRefreshing = false,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [books, isRefreshing, hasMore];
}

class BookEmpty extends BookState {}

class BookError extends BookState {
  final String message;

  BookError(this.message);

  @override
  List<Object?> get props => [message];
}
