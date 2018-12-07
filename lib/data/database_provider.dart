import 'package:sqflite/sqflite.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/data/read_entry.dart';
import 'package:track_it/data/timeseries_pages.dart';

class DatabaseProvider {
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

  Future<List<ReadEntry>> getAllEntries() async {
    List<Map> maps = await db.query(tableReadEntry);
    return maps.map((m) => ReadEntry.fromMap(m)).toList();
  }

  Future<List<TimeSeriesPages>> getTimeSeriesPages(int numberOfDays) async {
    DateTime today = DateTime.now();
    int millisPerDay = 86400000;
    int numberOfMillis = numberOfDays * millisPerDay;
    int todaysMillis = DateTime(today.year, today.month, today.day).add(Duration(days: 1)).millisecondsSinceEpoch ;
    int startMillis = todaysMillis - numberOfMillis;

    List<Map> maps = await db.query(tableReadEntry,
      where: '$columnDate > ?',
      whereArgs: [startMillis]);
    List<ReadEntry> entries = maps.map((m) => ReadEntry.fromMap(m)).toList();

    Map<int, List<ReadEntry>> entriesPerDay = {};
    entries.forEach((entry) {
      DateTime day = DateTime(
          entry.dateTime.year,
          entry.dateTime.month,
          entry.dateTime.day);
      if (entriesPerDay.containsKey(day.millisecondsSinceEpoch)){
        entriesPerDay[day.millisecondsSinceEpoch].add(entry);
      } else {
        entriesPerDay[day.millisecondsSinceEpoch] = [entry];
      }
    });

    List<TimeSeriesPages> timeSeriesPages = [];
    for(var currentMillis = startMillis; currentMillis <= todaysMillis; currentMillis += millisPerDay) {
      if (entriesPerDay.containsKey(currentMillis)) {
        var sum = 0;
        entriesPerDay[currentMillis].forEach((e) {
          sum += e.pagesRead;
        });
        timeSeriesPages.add(TimeSeriesPages(DateTime.fromMillisecondsSinceEpoch(currentMillis), sum));
      } else {
        timeSeriesPages.add(TimeSeriesPages(DateTime.fromMillisecondsSinceEpoch(currentMillis), 0));
      }
    }

    return timeSeriesPages;
  }
}