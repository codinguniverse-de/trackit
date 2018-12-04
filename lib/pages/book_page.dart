import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/price_tag.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/util/localization.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

enum Choice { edit, delete }

class BookPage extends StatefulWidget {
  final Book book;

  BookPage(this.book);

  @override
  State<StatefulWidget> createState() {
    return _BookPageState();
  }
}

class _BookPageState extends State<BookPage> {

  double _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.book.rating == null ? 0.0 : widget.book.rating.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<BooksModel>(
      builder: (context, _, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.book.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed('/edit/${widget.book.id}');
                },
              ),
              PopupMenuButton<Choice>(
                onSelected: (Choice choice) {
                  switch(choice) {
                    case Choice.delete:
                      model.deleteBook(widget.book.id);
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
                      PriceTag(value: widget.book.price),
                    ],
                  ),
                  _buildAuthor(),
                  _buildPublisher(context),
                  _buildRatingBar(model),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildImage() {
    if (widget.book.imageUrl == null || widget.book.imageUrl.isEmpty) {
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
        image: NetworkImage(widget.book.imageUrl),
      );
    }
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.book.title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAuthor() {
    return Text(
      widget.book.authors.join(','),
      style: TextStyle(fontSize: 20.0, color: Colors.black54),
    );
  }

  Widget _buildPublisher(BuildContext context) {
    if (widget.book.publisher == null || widget.book.publisher.isEmpty)
      return SizedBox();
    else
      return Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(
          Localization.of(context).publishedBy + widget.book.publisher,
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      );
  }

  Widget _buildRatingBar(BooksModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: SmoothStarRating(
        allowHalfRating: false,
        starCount: 5,
        size: 40.0,
        onRatingChanged: (value) {
          setState(() {
            _selectedRating = value;
            var newBook = widget.book;
            newBook.rating = value.toInt();
            model.updateBook(newBook);
          });
        },
        rating: _selectedRating,
      ),
    );
  }
}
