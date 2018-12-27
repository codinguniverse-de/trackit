
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_database.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';
import 'package:track_it/data/timeseries_minutes.dart';

mixin PodcastModel on Model {
  bool podcastsLoading = false;
  PodcastDatabase _database = PodcastDatabase();
  List<Podcast> podcasts = [];


  Future<bool> podcastIsAdded(var podcastId) async {
    return await _database.podcastIsAdded(podcastId);
  }

  Future fetchPodcasts() async {
    podcastsLoading = true;
    notifyListeners();
    podcasts = await _database.getPodcasts();
    podcastsLoading = false;
    notifyListeners();
  }

  Future addPodcast(Podcast podcast) async {
    await _database.insertPodcast(podcast);
    for(var episode in podcast.episodes) {
        await _database.insertEpisode(episode);
    }
    podcasts.add(podcast);
    notifyListeners();
  }

  void toggleListened(PodcastEpisode episode) async {
    episode.listened = !episode.listened;
    episode.listenedAt = episode.listened ? DateTime.now() : null;
    notifyListeners();
    await _database.updateEpisode(episode);
  }

  Future<List<TimeSeriesMinutes>> getTimeSeriesMinutes(int days) async {
    return await _database.getTimeSeriesMinutes(days);
  }

  Future<int> getTotalTime() async {
    return await _database.getTotalTimeListened();
  }

  Future<List<PodcastEpisode>> getAllEpisodesListened() async {
    return await _database.getAllEpisodesListened();
  }

  Future deletePodcast(int id) async {
    await _database.deletePodcast(id);
    podcasts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}