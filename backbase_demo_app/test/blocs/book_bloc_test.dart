import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:backbase_demo_app/domain/entities/book_entity.dart';
import 'package:backbase_demo_app/domain/repositories/book_repository.dart';
import 'package:backbase_demo_app/presentation/bloc/book_bloc.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  late BookBloc bookBloc;
  late MockBookRepository mockRepository;

  final mockBooksPage1 = List.generate(
    10,
        (index) => BookEntity(
      title: 'Book $index',
      author: 'Author $index',
      coverUrl: '', key:'',
    ),
  );

  setUp(() {
    mockRepository = MockBookRepository();
    bookBloc = BookBloc(mockRepository);
  });

  tearDown(() {
    bookBloc.close();
  });

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookLoaded] when SearchBooks is added and books are fetched successfully',
    build: () {
      when(() => mockRepository.searchBooks('flutter', 1))
          .thenAnswer((_) async => mockBooksPage1);
      return bookBloc;
    },
    act: (bloc) => bloc.add(SearchBooks('flutter', page: 1)),
    expect: () => [
      BookLoading(),
      BookLoaded(books: mockBooksPage1, hasMore: true),
    ],
    verify: (_) {
      verify(() => mockRepository.searchBooks('flutter', 1)).called(1);
    },
  );

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookEmpty] when no books are returned',
    build: () {
      when(() => mockRepository.searchBooks('@', 1))
          .thenAnswer((_) async => []);
      return bookBloc;
    },
    act: (bloc) => bloc.add(SearchBooks('@', page: 1)),
    expect: () => [
      BookLoading(),
      BookLoaded(books: [], hasMore: false),
    ],
  );

  blocTest<BookBloc, BookState>(
    'emits [BookLoading, BookError] when API throws an error',
    build: () {
      when(() => mockRepository.searchBooks('', 1))
          .thenThrow(Exception('API Error'));
      return bookBloc;
    },
    act: (bloc) => bloc.add(SearchBooks('error', page: 1)),
    expect: () => [
      BookLoading(),
      BookError('Failed to load books'),
    ],
  );
}
