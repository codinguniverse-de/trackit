import 'package:flutter/material.dart';
import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/books_api.dart';
import 'package:track_it/data/api/schemes/book_scheme.dart';

class SearchBookPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchBookPageState();
  }
}

class _SearchBookPageState extends State<SearchBookPage> {
  String _searchString = '';
  List<BookScheme> _results;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suche'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchString = value;
                      });
                    },
                  )),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      var result = await BooksApi().fetchBooks(_searchString);
                      print(result.data);
                      if (result.result == Result.SUCCESS) {
                        setState(() {
                          _results = result.data;
                        });
                      }
                    },
                  )
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
    if (_results == null) {
      return Container();
    }
    if (_results.length == 0) return Center(child: Text('No Results'));

    return ListView.builder(
      itemBuilder: _buildItems,
      itemCount: _results.length,
    );
  }

  Widget _buildItems(BuildContext context, int index) {
    var book = _results[index];
    return Column(
      children: <Widget>[
        ListTile(
            leading: book.thumbnailPath != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(book.thumbnailPath))
                : null,
            title: Text(_results[index].title),
            subtitle: Text(_results[index].subTitle)),
        Divider(),
      ],
    );
  }
}
