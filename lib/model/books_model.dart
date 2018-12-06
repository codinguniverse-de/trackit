import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/data/database_provider.dart';
import 'package:track_it/data/read_entry.dart';
import 'package:track_it/data/timeseries_pages.dart';

class BooksModel extends Model {
  List<Book> _books = [];
  DatabaseProvider _provider;
  bool _isLoading = false;
  String _searchTerm = '';
  int _pagesRead = 0;
  int _selectedBookId = -1;

  BooksModel() {
    _provider = DatabaseProvider();
  }

  List<Book> get books {
    return _books;
  }

  int get currentPages {
    return _pagesRead;
  }

  double get currentProgress {
    return _pagesRead / selectedBook.numPages;
  }

  Book get selectedBook {
    return _books.firstWhere((b) => b.id == _selectedBookId);
  }

  List<Book> get filteredBooks {
    if (_searchTerm.isEmpty) return _books;
    return _books
        .where((book) =>
            book.title.contains(_searchTerm) ||
            book.authors.any((author) => author.contains(_searchTerm)))
        .toList();
  }

  get isLoading => _isLoading;

  void selectBook(int bookId) async {
    _selectedBookId = bookId;
    _pagesRead = await getPagesReadForBook(bookId) ?? 0;
  }

  void fetchBooks() async {
    _isLoading = true;
    await _provider.open('books.db');
    var books = await _provider.getAll();
    _isLoading = false;
    if (books != null) {
      _books = await _provider.getAll();
      notifyListeners();
    }
  }

  void saveBook(Book book) async {
    await _provider.insert(book);
    _books.add(book);
    notifyListeners();
  }

  void deleteBook(int id) async {
    await _provider.delete(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }

  void updateBook(Book book) async {
    await _provider.update(book);
    int changedIndex = _books.indexWhere((b) => b.id == book.id);
    if (changedIndex != -1) {
      _books[changedIndex] = book;
    }
    notifyListeners();
  }

  Future<int> getPagesReadForBook(int bookId) async {
    return await _provider.getSumForBook(bookId);
  }

  void search(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  void addReadEntry(int bookId, int pages) async {
    var entry = ReadEntry(
      dateTime: DateTime.now(),
      bookId: bookId,
      pagesRead: pages,
    );
    await _provider.addReadEntry(entry);
    _pagesRead = await getPagesReadForBook(bookId);
    notifyListeners();
  }

  Future<List<ReadEntry>> getAllEntries() async {
    return await _provider.getAllEntries();
  }

  Future<List<TimeSeriesPages>> getTimeSeriesPages(int days) async {
    return await _provider.getTimeSeriesPages(days);
  }
}
