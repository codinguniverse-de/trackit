import 'package:flutter/material.dart';

final String tableReadEntry = 'readEntries';
final String columnId = 'id';
final String columnDate = 'dateTime';
final String columnPagesRead = 'pagesRead';
final String columnBookId = 'bookId';

class ReadEntry {
  int id;
  DateTime dateTime;
  int pagesRead;
  int bookId;

  ReadEntry({
    this.id,
    @required this.dateTime,
    @required this.pagesRead,
    @required this.bookId,
  });

  Map<String, dynamic> toMap() {
    var map = {
      columnId: id,
      columnDate: dateTime.millisecondsSinceEpoch,
      columnPagesRead: pagesRead,
      columnBookId: bookId
    };
    return map;
  }

  ReadEntry.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map[columnDate]);
    pagesRead = map[columnPagesRead];
    bookId = map[columnBookId];
  }
}
