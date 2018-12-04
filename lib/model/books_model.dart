import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';

class BooksModel extends Model {
  List<Book> _books = [];
  BookProvider _provider;
  String _searchTerm = '';

  BooksModel(){
    _provider = BookProvider();
  }

  List<Book> get books {
    return _books;
  }

  List<Book> get filteredBooks {
    if (_searchTerm.isEmpty)
      return _books;
    return _books.where((book) => book.title.contains(_searchTerm)
    || book.authors.any((author) => author.contains(_searchTerm))).toList();
  }

  void fetchBooks() async{
    await _provider.open('books.db');
    var books = await _provider.getAll();
    if(books != null) {
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

  void search(String value) {
    _searchTerm = value;
    notifyListeners();
  }

}