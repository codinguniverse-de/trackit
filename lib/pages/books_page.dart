import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/book_list_item.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/util/localization.dart';

class BooksPage extends StatefulWidget {
  final BooksModel _model;

  BooksPage(this._model);

  @override
  State<StatefulWidget> createState() {
    return _BooksPage();
  }
}

class _BooksPage extends State<BooksPage> {
  @override
  void initState() {
    super.initState();
    widget._model.fetchBooks();
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksModel>(
      builder: (context, widget, model) {
        return Scaffold(
          drawer: SideDrawer(),
          appBar: AppBar(
            title: Text(Localization.of(context).appTitle),
          ),
          body: buildListView(model),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _onAddBook(context, model),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        );
      },
    );
  }

  Widget buildListView(BooksModel model) {
    return model.books.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BookListItem(
                book: model.books[index],
                onTap: () => Navigator.of(context)
                    .pushNamed('/book/${model.books[index].id}'),
              );
            },
            itemCount: model.books.length,
          )
        : Center(
            child: Text(Localization.of(context).addBooks),
          );
  }

  void _onAddBook(BuildContext context, BooksModel model) {
    Navigator.of(context).pushNamed('/create');
  }
}
