import 'dart:async';
import 'package:flutter/material.dart';
import 'package:track_it/data/category.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_it/data/read_entry.dart';

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

class BookProvider {
  Database db;

  Future<Null> open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        create table $tableReadEntry (
          $columnId integer primary key autoincrement,
          $columnBookId integer,
          $columnPagesRead integer,
          $columnDate integer)
      ''');
      await db.execute('''
        create table $tableBook (
          $columnId integer primary key autoincrement,
          $columnTitle text not null,
          $columnAuthor text not null,
          $columnPrice real not null,
          $columnNumPages integer not null,
          $columnPublisher text,
          $columnImageUrl text,
          $columnRating int,
          $columnFinished int)
      ''');
    });
  }

  Future<Book> insert(Book book) async {
    book.id = await db.insert(tableBook, book.toMap());
    return book;
  }

  Future<ReadEntry> addReadEntry(ReadEntry entry) async {
    entry.id = await db.insert(tableReadEntry, entry.toMap());
    return entry;
  }

  Future<int> getSumForBook(int bookId) async {
    List<Map> maps = await db.query(
      tableReadEntry,
      where: '$columnBookId = ?',
      whereArgs: [bookId],
    );
    List<ReadEntry> entries = maps.map((m) => ReadEntry.fromMap(m)).toList();
    int pages = 0;
    entries.forEach((e) => pages += e.pagesRead);
    return pages;
  }

  Future<List<Book>> getAll() async {
    List<Map> maps = await db.query(tableBook);
    if (maps != null) {
      List<Book> books = [];
      maps.forEach((map) {
        books.add(Book.fromMap(map));
      });
      return books;
    }
    return [];
  }

  Future<Book> getBook(int id) async {
    List<Map> maps =
        await db.query(tableBook, where: '$columnId = ?', whereArgs: [id]);

    if (maps.length > 0) {
      return new Book.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableBook,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(Book book) async {
    return await db.update(
      tableBook,
      book.toMap(),
      where: '$columnId = ?',
      whereArgs: [book.id],
    );
  }

  Future close() async => db.close();
}
