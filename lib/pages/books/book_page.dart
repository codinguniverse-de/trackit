import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/book/price_tag.dart';
import 'package:track_it/common/slider_input.dart';
import 'package:track_it/data/book/book.dart';
import 'package:track_it/model/main_model.dart';
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
  int _selectedPages;

  @override
  void initState() {
    super.initState();

    _selectedRating =
        widget.book.rating == null ? 0.0 : widget.book.rating.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context, _, model) {
      return Scaffold(
        appBar: buildAppBar(context, model),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _buildImage(),
                buildProgressIndicator(model),
                _buildTitle(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildAuthor(),
                    SizedBox(
                      width: 10.0,
                    ),
                    PriceTag(value: widget.book.price),
                  ],
                ),
                _buildPublisher(context),
                _buildRatingBar(model),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => onAddReadEntry(model),
        ),
      );
    });
  }

  AppBar buildAppBar(BuildContext context, MainModel model) {
    return AppBar(
        title: Text(widget.book.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed('/edit/${widget.book.id}');
            },
          ),
          PopupMenuButton<Choice>(
            onSelected: (Choice choice) {
              switch (choice) {
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
                      value: Choice.delete),
                ],
          )
        ],
      );
  }

  Row buildProgressIndicator(MainModel model) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LinearProgressIndicator(
            value: model.currentProgress,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            model.currentPages.toString() +
                ' / ' +
                widget.book.numPages.toString() +
                ' ' +
                Localization.of(context).pages,
          ),
        ),
      ],
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
      return Container(
          width: 160.0,
          height: 160.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(
                File(widget.book.imageUrl),
              ),
            ),
          ));
    }
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        widget.book.title,
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAuthor() {
    return Text(
      widget.book.authors.join(','),
      style: Theme.of(context).textTheme.subhead,
    );
  }

  Widget _buildPublisher(BuildContext context) {
    if (widget.book.publisher == null || widget.book.publisher.isEmpty)
      return SizedBox();
    else
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(
          Localization.of(context).publishedBy + widget.book.publisher,
          style: Theme.of(context).textTheme.body1,
          textAlign: TextAlign.center,
        ),
      );
  }

  Widget _buildRatingBar(MainModel model) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: SmoothStarRating(
        allowHalfRating: false,
        starCount: 5,
        size: 40.0,
        color: Theme.of(context).accentColor,
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

  void onAddReadEntry(MainModel model) {
    _selectedPages = model.currentPages;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  Localization.of(context).editProgress,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SliderInput(
                  maxValue: widget.book.numPages,
                  initialValue: model.currentPages,
                  onChange: (value) {
                    setState(() {
                      _selectedPages = value;
                    });
                  },
                ),
              ],
            ),
          );
        }).then((_) {
      var delta = _selectedPages - model.currentPages;
      if (delta > 0) {
        model.addReadEntry(widget.book.id, delta);
      }
    });
  }
}
