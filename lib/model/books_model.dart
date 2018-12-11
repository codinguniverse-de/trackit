import 'package:flutter/src/widgets/icon_data.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/data/database_provider.dart';
import 'package:track_it/data/read_entry.dart';
import 'package:track_it/data/timeseries_pages.dart';
import 'package:track_it/pages/books_page.dart';

class BooksModel extends Model {
  List<Book> _books = [];
  List<Book> _filteredList = [];
  DatabaseProvider _provider;
  FilterMode _filterMode = FilterMode.ALL;
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
    return _filteredList;
  }

  get isLoading => _isLoading;

  FilterMode get filterMode => _filterMode;

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
      await filterAndSearch();
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

  void search(String value) async {
    _searchTerm = value;
    await filterAndSearch();
    notifyListeners();
  }

  void setFilterMode(FilterMode mode) async {
    _filterMode = mode;
    await filterAndSearch();
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

  Future<double> getAveragePerDay(int days) async {
    return await _provider.getAveragePerDay(days);
  }

  Future<int> getTotalPages() async {
    return await _provider.getTotalPages();
  }

  filterAndSearch() async {
    _filteredList = await filter();

    if (_searchTerm != null && _searchTerm.isNotEmpty) {
      _filteredList =  _filteredList
          .where((book) =>
      book.title.contains(_searchTerm) ||
          book.authors.any((author) => author.contains(_searchTerm)))
          .toList();
    }
  }

  Future<List<Book>> filter() async {
    List<Book> filtered = [];
    switch(_filterMode) {
      case FilterMode.ALL:
        return _books;
      case FilterMode.CURRENTLY_READING:
        for (final book in _books) {
          var readPages = await _provider.getSumForBook(book.id);
          if (readPages < book.numPages) {
            filtered.add(book);
          }
        }
        return filtered;
      case FilterMode.FINISHED:
        for (final book in _books) {
          var readPages = await _provider.getSumForBook(book.id);
          if (readPages >= book.numPages) {
            filtered.add(book);
          }
        }
        return filtered;
      case FilterMode.THIS_YEAR:
        var allEntries = await _provider.getAllEntries();
        int year = DateTime.now().year;
        DateTime yearStart = DateTime(year);
        var entriesThisYear = allEntries.where((entry) => entry.dateTime.isAfter(yearStart));
        entriesThisYear.forEach((entry) {
          var book = _books.firstWhere((book) => book.id == entry.bookId);
          if (!filtered.contains(book)) {
            filtered.add(book);
          }
        });

        return filtered;
    }
    return [];
  }

  Future<double> getTotalPrice() async {
    return await _provider.getTotalPrice();
  }
}
