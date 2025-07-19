import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/book_repository.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc(this.repository) : super(BookInitial()) {
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onSearchBooks(SearchBooks event, Emitter<BookState> emit) async {
    try {
      if (event.page == 1) {
        emit(BookLoading());
      }

      final newBooks = await repository.searchBooks(event.query, event.page);
      final currentBooks = state is BookLoaded && event.page > 1
          ? (state as BookLoaded).books
          : [];

      final hasMore = newBooks.isNotEmpty;

      emit(BookLoaded(books: [...currentBooks, ...newBooks], hasMore: hasMore));

    } catch (e) {
      emit(BookError('Failed to load books'));
    }
  }
}
