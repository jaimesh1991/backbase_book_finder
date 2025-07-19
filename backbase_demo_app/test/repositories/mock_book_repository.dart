import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:your_app/bloc/book_bloc.dart';
// import 'package:your_app/models/book_entity.dart';
// import 'package:your_app/repositories/book_repository.dart';
import 'package:backbase_demo_app/domain/repositories/book_repository.dart';

class MockBookRepository extends Mock implements BookRepository {}
