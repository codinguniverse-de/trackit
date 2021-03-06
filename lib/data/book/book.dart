import 'package:flutter/material.dart';
import 'package:track_it/data/category.dart';

final String tableBook = 'books';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnAuthor = 'author';
final String columnPrice = 'price';
final String columnNumPages = 'numPages';
final String columnPublisher = 'publisher';
final String columnImageUrl = 'imageUrl';
final String columnRating = 'rating';
final String columnFinished = 'finished';

class Book {
  int id;
  String title;
  List<String> authors;
  String publisher;
  double price;
  int numPages;
  Category category;
  String imageUrl;
  int rating;
  bool finished;

  Book(
      {@required this.id,
      @required this.title,
      @required this.authors,
      this.publisher,
      @required this.price,
      @required this.numPages,
      this.category,
      this.imageUrl});

  Map<String, dynamic> toMap() {
    var map = {
      columnId: id,
      columnTitle: title,
      columnAuthor: authors[0],
      columnPublisher: publisher,
      columnPrice: price,
      columnNumPages: numPages,
      columnImageUrl: imageUrl,
      columnRating: _parseRating(rating),
      columnFinished: finished ? 1 : 0,
    };
    return map;
  }

  Book.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    authors = [map[columnAuthor]];
    publisher = map[columnPublisher];
    price = map[columnPrice];
    numPages = map[columnNumPages];
    imageUrl = map[columnImageUrl];
    rating = map[columnRating];
    finished = map[columnFinished] == 1;
  }

  int _parseRating(int rating) {
    if (rating == null) {
      rating = 0;
      return rating;
    }

    if (rating < 1)
      rating = 1;
    else if (rating > 5) rating = 5;
    return rating;
  }
}
