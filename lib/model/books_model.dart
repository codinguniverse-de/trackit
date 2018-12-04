import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';

class BooksModel extends Model {
  List<Book> _books = [];
  BookProvider _provider;

  BooksModel(){
    _provider = BookProvider();
  }

  List<Book> get books {
    return _books;
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
}