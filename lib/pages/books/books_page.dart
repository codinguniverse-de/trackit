import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/book/book_list_item.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/localization.dart';

class BooksPage extends StatefulWidget {
  final MainModel _model;

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
    return ScopedModelDescendant<MainModel>(
      builder: (context, widget, model) {
        return Scaffold(
          drawer: SideDrawer(),
          appBar: buildAppBar(context, model),
          body: buildListView(model),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _onAddBook(context),
          ),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context, MainModel model) {
    var icon = Icon(_searchMode ? Icons.clear : Icons.search);
    var filterIcon = Icon(model.filterMode == FilterMode.ALL
        ? Icons.filter_list
        : Icons.delete_sweep);
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
        PopupMenuButton<FilterMode>(
          icon: filterIcon,
          onSelected: (mode) {
            widget._model.setFilterMode(mode);
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<FilterMode>(
                value: FilterMode.ALL,
                child: ListTile(
                  leading: model.filterMode == FilterMode.ALL ? Icon(Icons.check) : null,
                  title: Text(Localization.of(context).all),
                ),
              ),
              PopupMenuItem<FilterMode>(
                value: FilterMode.CURRENTLY_READING,
                child: ListTile(
                  leading: model.filterMode == FilterMode.CURRENTLY_READING ? Icon(Icons.check) : null,
                  title: Text(Localization.of(context).currentlyReading),
                ),
              ),
              PopupMenuItem<FilterMode>(
                value: FilterMode.THIS_YEAR,
                child: ListTile(
                  leading: model.filterMode == FilterMode.THIS_YEAR ? Icon(Icons.check) : null,
                  title: Text(Localization.of(context).thisYear),
                ),
              ),
              PopupMenuItem<FilterMode>(
                value: FilterMode.FINISHED,
                child: ListTile(
                  leading: model.filterMode == FilterMode.FINISHED ? Icon(Icons.check) : null,
                  title: Text(Localization.of(context).finished),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget buildListView(MainModel model) {
    if (model.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return model.filteredBooks.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BookListItem(
                book: model.filteredBooks[index],
                onTap: () {
                  model.selectBook(model.filteredBooks[index].id);
                  Navigator.of(context)
                      .pushNamed('/book/${model.filteredBooks[index].id}');
                },
              );
            },
            itemCount: model.filteredBooks.length,
          )
        : Center(
            child: Text(Localization.of(context).addBooks),
          );
  }

  void _onAddBook(BuildContext context) {
    Navigator.of(context).pushNamed('/create');
  }
}

enum FilterMode { ALL, THIS_YEAR, FINISHED, CURRENTLY_READING }
