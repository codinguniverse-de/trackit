
import 'package:track_it/data/api/schemes/episode_scheme.dart';

final String tableEpisode = 'episodes';
final String _columnId = 'id';
final String columnPodcastId = 'podcast_id';
final String columnEpisodeTitle = 'title';
final String columnEpisodeDescription = 'description';
final String columnEpisodeLength = 'duration';
final String columnPublishDate = 'pubdate';
final String columnListened = 'listened';
final String columnListenedAt = 'listenedAt';


class PodcastEpisode {
  int id;
  int podcastId;
  String title;
  String description;
  int length;
  bool listened;
  DateTime publishedAt;
  DateTime listenedAt;

  PodcastEpisode({
    this.podcastId,
    this.title,
    this.description,
    this.length,
    this.publishedAt,
    this.listened,
    this.listenedAt
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
      columnListenedAt: listenedAt == null ? null : listenedAt.millisecondsSinceEpoch
    };
    return map;
  }

  PodcastEpisode.fromMap(Map<String, dynamic> map) {
    if (map[_columnId] is String) {
      map[_columnId] = int.parse(map[_columnId]);
    }
    id = map[_columnId];
    title = map[columnEpisodeTitle];
    description = map[columnEpisodeDescription];
    if (map[columnPodcastId] is String) {
      map[columnPodcastId] = int.parse(map[columnPodcastId]);
    }
    podcastId = map[columnPodcastId];
    length = map[columnEpisodeLength];
    if (map[columnPublishDate] is String) {
      publishedAt = DateTime.parse(map[columnPublishDate]);
    } else {
      publishedAt = DateTime.fromMillisecondsSinceEpoch(map[columnPublishDate]);
    }
    listened = map[columnListened] == 1;
    listenedAt = map[columnListenedAt] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[columnListenedAt]);
  }

  PodcastEpisode.fromScheme(EpisodeScheme scheme) {
    id = scheme.id;
    title = scheme.title;
    description = scheme.description;
    podcastId = scheme.podcastId;
    length = scheme.length;
    publishedAt = scheme.pubDate;
    listened = false;
    listenedAt = null;
  }
}
