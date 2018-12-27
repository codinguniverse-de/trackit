import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:track_it/data/api/schemes/book_scheme.dart';
import 'package:track_it/util/localization.dart';

class SearchBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchBookPageState();
  }
}

class _SearchBookPageState extends State<SearchBookPage> {
  String _searchString = '';
  List<BookSchemeGraphQL> _results = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).search),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: Localization.of(context).startTyping
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchString = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_searchString.length < 5) return Container();
    var query = """
     query {
      searchBook(term: \"$_searchString\") {
        id
        volumeInfo {
          title
          authors
          publisher
          description
          industryIdentifiers {
            type
            identifier
          }
          pageCount
          imageLinks {
            smallThumbnail
          }
          language
        }
        saleInfo {
          listPrice {
            amount
            currencyCode
          }
        }
      }
     }
    """
        .replaceAll('\n', ' ');
    return Query(
      query,
      pollInterval: 5,
      builder: ({
        bool loading,
        var data,
        Exception error,
      }) {
        if (error != null) {
          return Text(error.toString());
        }
        if (loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List books = data['searchBook'];
        _results.clear();
        for (var book in books) {
          _results.add(BookSchemeGraphQL.fromMap(book));
        }
        print(_results.length);
        return ListView.builder(
          itemBuilder: _buildItems,
          itemCount: _results.length,
        );
      },
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    var book = _results[index];
    return Column(
      children: <Widget>[
        ListTile(
          leading: book.volumeInfo.imageLinks.smallThumbnail != null
              ? CircleAvatar(
                  backgroundImage:
                      NetworkImage(book.volumeInfo.imageLinks.smallThumbnail))
              : Image.asset(
                  'assets/book_icon.png',
                  width: 40.0,
                ),
          title: Text(_results[index].volumeInfo.title),
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop(book);
              }),
        ),
        Divider(),
      ],
    );
  }
}
