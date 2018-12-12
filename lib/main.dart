import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/book/book.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/books/book_page.dart';
import 'package:track_it/pages/books/books_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:track_it/pages/books/edit_book_page.dart';
import 'package:track_it/pages/podcasts/add_podcast_page.dart';
import 'package:track_it/pages/podcasts/podcasts_page.dart';
import 'package:track_it/pages/settings_page.dart';
import 'package:track_it/pages/statistics_page.dart';
import 'package:track_it/util/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final model = MainModel();
  Brightness _theme = Brightness.light;
  Widget _startPage;

  @override
  void initState() {
    super.initState();
    getStartPage();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
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
          brightness: _theme,
        ),
        routes: {
          '/': (BuildContext context) => _startPage,
          '/books': (BuildContext context) => BooksPage(model),
          '/create': (BuildContext context) => EditBookPage(),
          '/podcasts': (BuildContext context) => PodcastsPage(model),
          '/addpodcast': (BuildContext context) => AddPodcastPage(),
          '/settings': (BuildContext context) => SettingsPage(
                themeChanged: themeChanged,
                startPageChanged: startpageChanged,
              ),
          '/statistics': (BuildContext context) => StatisticsPage(model),
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
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => BooksPage(model)),
      ),
    );
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String theme = prefs.getString('theme') ?? 'light';

    switch (theme) {
      case 'light':
        setState(() {
          _theme = Brightness.light;
        });
        model.theme = Brightness.light;
        break;
      case 'dark':
        setState(() {
          _theme = Brightness.dark;
        });
        model.theme = Brightness.dark;
        break;
    }
  }

  void themeChanged(Brightness theme) async {
    setState(() {
      _theme = theme;
    });
    model.theme = theme;
    String value = 'light';
    switch (theme) {
      case Brightness.dark:
        value = 'dark';
        break;
      case Brightness.light:
        value = 'light';
        break;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', value);
  }

  void startpageChanged(StartPage startPage) async {
    model.startPage = startPage;
    String value = 'books';
    switch (startPage) {
      case StartPage.BOOKS:
        value = 'books';
        setState(() {
          _startPage = BooksPage(model);
        });
        break;
      case StartPage.PODCASTS:
        value = 'podcasts';
        setState(() {
          _startPage = PodcastsPage(model);
        });
        break;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('startpage', value);
  }

  void getStartPage() async {
    _startPage = BooksPage(model);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String startPage = prefs.getString('startpage') ?? 'books';

    switch (startPage) {
      case 'books':
        setState(() {
          _startPage = BooksPage(model);
        });
        model.startPage = StartPage.BOOKS;
        break;
      case 'podcasts':
        setState(() {
          _startPage = PodcastsPage(model);
        });
        model.startPage = StartPage.PODCASTS;
        break;
    }
  }
}
