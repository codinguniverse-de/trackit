import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/price_tag.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/util/localization.dart';

enum Choice { edit, delete }

class BookPage extends StatelessWidget {
  final Book book;

  BookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksModel>(
      builder: (context, widget, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(book.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit/${book.id}');
                },
              ),
              PopupMenuButton<Choice>(
                onSelected: (Choice choice) {
                  switch(choice) {
                    case Choice.delete:
                      model.deleteBook(book.id);
                      Navigator.of(context).pop();
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Choice>>[
                  PopupMenuItem<Choice>(
                      child: Text(Localization.of(context).delete),
                      value: Choice.delete
                  ),
                ],
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildImage(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTitle(),
                      PriceTag(value: book.price),
                    ],
                  ),
                  _buildAuthor(),
                  _buildPublisher(context),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildImage() {
    if (book.imageUrl == null || book.imageUrl.isEmpty) {
      return Image.asset(
        'assets/book_icon.png',
        fit: BoxFit.fitWidth,
        width: 160.0,
        height: 160.0,
      );
    } else {
      return FadeInImage(
        width: 160.0,
        height: 1600.0,
        placeholder: AssetImage('assets/book_icon.png'),
        image: NetworkImage(book.imageUrl),
      );
    }
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        book.title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAuthor() {
    return Text(
      book.authors.join(','),
      style: TextStyle(fontSize: 20.0, color: Colors.black54),
    );
  }

  Widget _buildPublisher(BuildContext context) {
    if (book.publisher == null || book.publisher.isEmpty)
      return SizedBox();
    else
      return Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(
          Localization.of(context).publishedBy + book.publisher,
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      );
  }
}
