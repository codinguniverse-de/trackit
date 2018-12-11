
import 'package:track_it/data/api/schemes/episode_scheme.dart';

final String tableEpisode = 'episodes';
final String _columnId = 'id';
final String columnPodcastId = 'podcastId';
final String columnEpisodeTitle = 'title';
final String columnEpisodeDescription = 'description';
final String columnEpisodeLength = 'length';
final String columnPublishDate = 'publishDate';
final String columnListened = 'listened';


class PodcastEpisode {
  int id;
  int podcastId;
  String title;
  String description;
  int length;
  bool listened;
  DateTime publishedAt;

  PodcastEpisode({
    this.podcastId,
    this.title,
    this.description,
    this.length,
    this.publishedAt,
    this.listened,
  });

  Map<String, dynamic> toMap() {
    var map = {
      _columnId: id,
      columnEpisodeTitle: title,
      columnEpisodeDescription: description,
      columnPodcastId: podcastId,
      columnEpisodeLength: length,
      columnPublishDate: publishedAt.millisecondsSinceEpoch,
      columnListened: listened ? 1 : 0,
    };
    return map;
  }

  PodcastEpisode.fromMap(Map<String, dynamic> map) {
    id = map[_columnId];
    title = map[columnEpisodeTitle];
    description = map[columnEpisodeDescription];
    podcastId = map[columnPodcastId];
    length = map[columnEpisodeLength];
    publishedAt = DateTime.fromMillisecondsSinceEpoch(map[columnPublishDate]);
    listened = map[listened] == 1;
  }

  PodcastEpisode.fromScheme(EpisodeScheme scheme) {
    id = scheme.id;
    title = scheme.title;
    description = scheme.description;
    podcastId = scheme.podcastId;
    length = scheme.length;
    publishedAt = scheme.pubDate;
    listened = false;
  }
}
