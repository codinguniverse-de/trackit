import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:track_it/util/localization_strings.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'de': de,
    'en': en,
  };

  _getValue(String key) => _localizedValues[locale.languageCode][key];

  String get startTyping => _getValue(StartTyping);
  String get podcastAdded => _getValue(PodcastAdded);
  String get lastUpdate => _getValue(LastUpdate);
  String get minutes => _getValue(Minutes);
  String get hours => _getValue(Hours);
  String get amountEpisodes => _getValue(AmountEpisodes);
  String get averageTime => _getValue(AverageTime);
  String get amountPodcasts => _getValue(AmountPodcasts);
  String get totalTime => _getValue(TotalTime);
  String get amountBooks => _getValue(AmountBooks);
  String get startPage => _getValue(StartPage);
  String get episodes => _getValue(Episodes);
  String get details => _getValue(Details);
  String get addPodcast => _getValue(AddPodcast);
  String get podcasts => _getValue(Podcasts);
  String get removeImage => _getValue(RemoveImage);
  String get gallery => _getValue(Gallery);
  String get takeImage => _getValue(TakeImage);
  String get all => _getValue(All);
  String get currentlyReading => _getValue(CurrentlyReading);
  String get thisYear => _getValue(ThisYear);
  String get finished => _getValue(Finished);
  String get averagePages => _getValue(AveragePages);
  String get totalPages => _getValue(TotalPages);
  String get totalPrice => _getValue(TotalPrice);
  String get search => _getValue(Search);
  String get noResults => _getValue(NoResults);
  String get fetchBooksFailed => _getValue(FetchBooksFailed);
  String get days => _getValue(Days);
  String get pagesPerDay => _getValue(PagesPerDay);
  String get editProgress => _getValue(EditProgress);
  String get exportSuccess => _getValue(ExportSuccess);
  String get import => _getValue(Import);
  String get export => _getValue(Export);
  String get statistics => _getValue(Statistics);
  String get settings => _getValue(Settings);
  String get pages => _getValue(Pages);
  String get addBooks => _getValue(AddBooks);
  String get booksDrawerItem => _getValue(BooksDrawerItem);
  String get delete => _getValue(Delete);
  String get appTitle => _getValue(AppTitle);
  String get registerTitle => _getValue(RegisterTitle);
  String get createBookTitle => _getValue(CreateBookTitle);
  String get editBookTitle => _getValue(EditBookTitle);
  String get bookTitle => _getValue(BookTitle);
  String get bookAuthor => _getValue(BookAuthor);
  String get bookPublisher => _getValue(BookPublisher);
  String get bookPrice => _getValue(BookPrice);
  String get bookPages => _getValue(BookPages);
  String get titleRequired => _getValue(TitleRequired);
  String get authorRequired => _getValue(AuthorRequired);
  String get priceRequired => _getValue(PriceRequired);
  String get pagesRequired => _getValue(PagesRequired);
  String get publishedBy => _getValue(PublishedBy);
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {

  LocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;
}