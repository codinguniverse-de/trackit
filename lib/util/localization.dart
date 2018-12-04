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