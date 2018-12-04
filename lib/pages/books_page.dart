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
  bool _searchMode = false;

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
          appBar: buildAppBar(context, model),
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

  AppBar buildAppBar(BuildContext context, BooksModel model) {
    var icon = Icon(_searchMode ? Icons.clear : Icons.search);
    var title = _searchMode
        ? TextField(
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            onChanged: (value) {
              model.search(value);
            },
          )
        : Text(Localization.of(context).appTitle);
    return AppBar(
      title: title,
      actions: <Widget>[
        IconButton(
          icon: icon,
          onPressed: () {
            model.search('');
            setState(() {
              _searchMode = !_searchMode;
            });
          },
        ),
      ],
    );
  }

  Widget buildListView(BooksModel model) {
    return model.filteredBooks.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BookListItem(
                book: model.filteredBooks[index],
                onTap: () => Navigator.of(context)
                    .pushNamed('/book/${model.filteredBooks[index].id}'),
              );
            },
            itemCount: model.filteredBooks.length,
          )
        : Center(
            child: Text(Localization.of(context).addBooks),
          );
  }

  void _onAddBook(BuildContext context, BooksModel model) {
    Navigator.of(context).pushNamed('/create');
  }
}
