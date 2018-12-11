
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/api/backend_response.dart';
import 'package:track_it/data/api/podcasts_api.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:track_it/data/podcasts/podcast.dart';

mixin PodcastModel on Model {
  bool podcastsLoading = false;
  PodcastsApi _api = new PodcastsApi();
  List<Podcast> podcasts = [
    Podcast(author: 'Daniel Korth', name: 'Finanzrocker'),
    Podcast(author: 'Seth Rogan', name: 'Smart Passive Incode', imageUrl: 'https://cdn.smartpassiveincome.com/wp-content/themes/rocket/img/podcast-tile-spi@2x.jpg'),
  ];

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
}