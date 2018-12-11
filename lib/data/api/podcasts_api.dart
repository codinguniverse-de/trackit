import 'dart:convert';

import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/schemes/episode_scheme.dart';
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
    return BackendResponse(Result.SUCCESS,
        results.map((map) => PodcastScheme.fromMap(map)).toList());
  }

  Future<BackendResponse<List<EpisodeScheme>>> getEpisodes(
      int podcastId) async {
    String episodesUrl =
        'https://api.fyyd.de/0.2/podcast/episodes?podcast_id=$podcastId&count=1000';
    http.Response response = await http.get(episodesUrl);
    if (response.statusCode != 201 && response.statusCode != 200) {
      return BackendResponse(Result.FAILURE, null);
    }

    Map<String, dynamic> responseData = json.decode(response.body);

    if (!responseData.containsKey('data')) {
      return BackendResponse(Result.FAILURE, null);
    }

    Map data = responseData['data'];

    if (!data.containsKey('episodes')) {
      return BackendResponse(Result.FAILURE, null);
    }
    List<dynamic> results = data['episodes'];
    return BackendResponse(Result.SUCCESS,
        results.map((map) => EpisodeScheme.fromMap(map)).toList());
  }
}
