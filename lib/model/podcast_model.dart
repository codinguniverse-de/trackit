
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/podcasts_api.dart';
import 'package:track_it/data/api/schemes/episode_scheme.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_database.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';

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
      for(var res in searchResults) {
        res.added = await _database.podcastIsAdded(res.podcastId);
      }
    }
    podcastsLoading = false;
    notifyListeners();
  }

  void fetchPodcasts() async {
    podcastsLoading = true;
    notifyListeners();
    await _database.open('podcasts.db');
    podcasts = await _database.getPodcasts();
    print(podcasts);
    podcastsLoading = false;
    notifyListeners();
  }

  void addPodcast(Podcast podcast) async {
    var schemeToAdd = searchResults.firstWhere((scheme) => scheme.podcastId == podcast.id);
    schemeToAdd.loadingAdd = true;
    notifyListeners();
    var response = await _api.getEpisodes(podcast.id);
    if (response.result == Result.SUCCESS) {
      var episodes = response.data;
      await _database.insertPodcast(podcast);
      for(var scheme in episodes) {
        var episode = PodcastEpisode.fromScheme(scheme);
        await _database.insertEpisode(episode);
        podcast.episodes.add(episode);
      }
      podcasts.add(podcast);
      schemeToAdd.added = true;
    }
    schemeToAdd.loadingAdd = false;
    notifyListeners();
  }

  void toggleListened(PodcastEpisode episode) async {
    episode.listened = !episode.listened;
    notifyListeners();
    await _database.updateEpisode(episode);
  }
}