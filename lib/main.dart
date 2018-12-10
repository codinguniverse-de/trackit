import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/pages/book_page.dart';
import 'package:track_it/pages/books_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:track_it/pages/camera_page.dart';
import 'package:track_it/pages/edit_book_page.dart';
import 'package:track_it/pages/settings_page.dart';
import 'package:track_it/pages/statistics_page.dart';
import 'package:track_it/util/localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final model = BooksModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<BooksModel>(
      model: model,
      child: MaterialApp(
        localizationsDelegates: [
          LocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('de', 'DE'),
        ],
        title: 'TrackIt',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          '/': (BuildContext context) => BooksPage(model),
          '/create': (BuildContext context) => EditBookPage(),
          '/settings': (BuildContext context) => SettingsPage(),
          '/statistics': (BuildContext context) => StatisticsPage(model),
          '/camera': (BuildContext context) => CameraPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'book') {
            final int bookId = int.parse(pathElements[2]);
            final Book book = model.books.firstWhere((b) => b.id == bookId);
            return MaterialPageRoute(
              builder: (BuildContext context) => BookPage(book),
            );
          } else if (pathElements[1] == 'edit') {
            final int bookId = int.parse(pathElements[2]);
            final Book book = model.books.firstWhere((b) => b.id == bookId);
            return MaterialPageRoute(
              builder: (BuildContext context) => EditBookPage(
                    editBook: book,
                  ),
            );
          }
        },
      ),
    );
  }
}
