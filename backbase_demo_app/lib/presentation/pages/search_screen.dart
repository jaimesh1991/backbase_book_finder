import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/book_local_datasource.dart';
import '../bloc/book_bloc.dart';
import '../widgets/book_tile.dart';
import '../widgets/book_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  String _currentQuery = '';
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _controller.text = "flutter";
    _currentQuery = _controller.text;
    _onSearch();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // debugPrint("Load More data");
        _loadMore();
      }
    });
  }

  void _onSearch({bool reset = true}) {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      setState(() {
        _currentQuery = '';
        _currentPage = 1;
      });
      final BookBloc bloc = context.read<BookBloc>();
      bloc.emit(BookEmpty()); // Emit new state
      return;
    }
    _currentPage = 1;
    _currentQuery = query;
    context.read<BookBloc>().add(SearchBooks(query, page: _currentPage));
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    context.read<BookBloc>().add(SearchBooks(_currentQuery, page: _currentPage));
  }

  void _loadMore() {
    if (!_isLoadingMore) {
      debugPrint("_isLoadingMore - true");
      _isLoadingMore = true;
      _currentPage++;
      debugPrint("_currentPage - $_currentPage");
      context.read<BookBloc>().add(SearchBooks(_currentQuery, page: _currentPage));
      Future.delayed(Duration(milliseconds: 500), () {
        _isLoadingMore = false;
      });
    }
  }

  void _showSavedBooksPopup(BuildContext context) async {
    final localDataSource = BookLocalDataSource();
    final books = await localDataSource.getAllBooks();

    if (books.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Saved Books'),
          content: Text('No saved records found.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Saved Books'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author ?? 'Unknown author'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              _showSavedBooksPopup(context);
            },
          ),
        ],),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Search books...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookInitial) {
                  return Center(child: Text('Start searching...'));
                } else if (state is BookEmpty) {
                  return Center(child: Text(
                    'Please enter a search term.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ));
                } else if (state is BookLoading && _currentPage == 1) {
                  return ListView.separated(
                    itemCount: 5,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) => const BookShimmer(),
                  );
                  // return Center(child: CircularProgressIndicator());
                } else if (state is BookLoaded) {
                  final books = state.books;
                  // final isRefreshing = state.isRefreshing;

                  if (books.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: books.length + (_isLoadingMore ? 1 : 0),//state.books.length + 1,
                      itemBuilder: (context, index) {
                        if (index < books.length) {
                          final book = books[index];
                          return BookTile(book: book);
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _isLoadingMore
                                  ? CircularProgressIndicator()
                                  : SizedBox.shrink(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is BookError) {
                  return Center(child: Text(state.message));
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
