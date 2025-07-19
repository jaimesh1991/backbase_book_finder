import 'package:backbase_demo_app/presentation/bloc/book_bloc.dart';
import 'package:backbase_demo_app/presentation/pages/details_screen.dart';
import 'package:backbase_demo_app/presentation/pages/search_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/book_repository_impl.dart';
import 'domain/repositories/book_repository.dart';

void main() {
  final BookRepository repo = BookRepositoryImpl(Dio());
  runApp(BookApp(repository: repo));
}

class BookApp extends StatelessWidget {
  final BookRepository repository;

  const BookApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: MaterialApp(
        title: 'Book Finder',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (_) => BlocProvider(
            create: (_) => BookBloc(repository),
            child: const SearchScreen(),
          ),
          '/details': (_) => const DetailsScreen(),
        },
      ),
    );
  }
}