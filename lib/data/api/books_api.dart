import 'dart:convert';

import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/schemes/book_scheme.dart';
import 'package:http/http.dart' as http;

class BooksApi {
  String fetchUrl = 'https://www.googleapis.com/books/v1/volumes?q=';
  Future<BackendResponse<List<BookScheme>>> fetchBooks(String isbn) async {
    http.Response response = await http.get(fetchUrl + isbn);
    if (response.statusCode != 201 && response.statusCode != 200) {
      return BackendResponse(Result.FAILURE, null);
    }

    Map<String, dynamic> responseData = json.decode(response.body);
    if (!responseData.containsKey('items')) {
      return BackendResponse(Result.FAILURE, null);
    }
    List<dynamic> entries = responseData['items'];
    List<BookScheme> schemes = [];
    entries.forEach((entry) {
      if (!entry.containsKey('volumeInfo')) return;
      Map volumeInfo = entry['volumeInfo'];
      Map imageLinks = tryGetValue(volumeInfo, 'imageLinks');
      String thumbnailPath;
      if (imageLinks != null) {
        thumbnailPath = tryGetValue(imageLinks, 'thumbnail');
      }
      var scheme = BookScheme(
        title: tryGetValue(volumeInfo, 'title'),
        subTitle: tryGetValue(volumeInfo, 'subtitle'),
        authors: tryGetValue(volumeInfo, 'authors'),
        pageCount: tryGetValue(volumeInfo, 'pageCount'),
        avgRating: tryGetValue(volumeInfo, 'averageRating'),
        publisher: tryGetValue(volumeInfo, 'publisher'),
        thumbnailPath: thumbnailPath,
        description: tryGetValue(volumeInfo, 'description'),
        isbn: isbn,
      );
      schemes.add(scheme);
    });
    return BackendResponse(Result.SUCCESS, schemes);
  }

  dynamic tryGetValue(Map map, dynamic key) {
    if (!map.containsKey(key)) {
      return null;
    }
    return map[key];
  }
}
