import 'dart:convert';

import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:http/http.dart' as http;

class PodcastsApi {
  String searchUrl = 'https://api.fyyd.de/0.2/search/podcast?term=';

  Future<BackendResponse<List<PodcastScheme>>> searchPodcasts(
      String searchTerm) async {
    http.Response response = await http.get(searchUrl + searchTerm);
    if (response.statusCode != 201 && response.statusCode != 200) {
      return BackendResponse(Result.FAILURE, null);
    }

    Map<String, dynamic> responseData = json.decode(response.body);
    if (!responseData.containsKey('data')) {
      return BackendResponse(Result.FAILURE, null);
    }
    List<dynamic> results = responseData['data'];
    List<PodcastScheme> schemes = [];
    results.forEach((entry) {
      schemes.add(PodcastScheme.fromMap(entry));
    });
    return BackendResponse(Result.SUCCESS,
        results.map((map) => PodcastScheme.fromMap(map)).toList());
  }
}
