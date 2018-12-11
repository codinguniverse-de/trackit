
final String tableEpisode = 'episodes';
final String _columnId = 'id';
final String columnPodcastId = 'podcastId';
final String columnEpisodeTitle = 'title';
final String columnEpisodeDescription = 'description';
final String columnEpisodeLength = 'length';
final String columnPublishDate = 'publishDate';


class PodcastEpisode {
  int id;
  int podcastId;
  String title;
  String description;
  int length;

  DateTime publishedAt;

  PodcastEpisode({
    this.podcastId,
    this.title,
    this.description,
    this.length,
    this.publishedAt,
  });

  Map<String, dynamic> toMap() {
    var map = {
      _columnId: id,
      columnEpisodeTitle: title,
      columnEpisodeDescription: description,
      columnPodcastId: podcastId,
      columnEpisodeLength: length,
      columnPublishDate: publishedAt.millisecondsSinceEpoch,
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
  }
}
