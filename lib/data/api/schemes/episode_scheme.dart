
class EpisodeScheme {
  int id;
  String title;
  String subtitle;
  String description;
  int numSeason;
  int podcastId;
  int numEpisode;
  int length;
  DateTime pubDate;

  EpisodeScheme.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    subtitle = map['subtitle'];
    length = map['duration'];
    podcastId = map['podcast_id'];
    description = map['description'];
    numSeason = map['num_season'];
    numEpisode = map['num_episode'];
    pubDate = DateTime.parse(map['pubdate']);
  }
}