
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/model/podcast_model.dart';

class MainModel extends Model with BooksModel, PodcastModel {
  Brightness _theme;

  Brightness get theme => _theme;

  set theme(Brightness theme) {
    _theme = theme;
    notifyListeners();
  }

}