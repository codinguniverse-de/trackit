
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/podcasts_api.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_database.dart';

mixin PodcastModel on Model {
  bool podcastsLoading = false;
  PodcastDatabase _database = PodcastDatabase();
  PodcastsApi _api = PodcastsApi();
  List<Podcast> podcasts = [];

  List<PodcastScheme> searchResults = [];

  void searchPodcasts(String value) async {
    podcastsLoading = true;
    notifyListeners();
    var response = await _api.searchPodcasts(value);
    if (response.result == Result.SUCCESS) {
      searchResults = response.data;
    }
    podcastsLoading = false;
    notifyListeners();
  }

  void fetchPodcasts() async {
    podcastsLoading = true;
    notifyListeners();
    await _database.open('podcasts.db');
    podcasts = await _database.getPodcasts();
    podcastsLoading = false;
    notifyListeners();
  }

  void addPodcast(Podcast podcast) async {
    await _database.insertPodcast(podcast);
    podcasts.add(podcast);
    notifyListeners();
  }
}