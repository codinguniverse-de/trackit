
import 'package:track_it/data/podcasts/podcast_episode.dart';

final String tablePodcast = 'podcasts';
final String _columnId = 'id';
final String columnName = 'name';
final String columnPodcastAuthor = 'author';
final String columnPodcastImage = 'imageUrl';

class Podcast {
  int id;
  String imageUrl;
  String name;
  String author;

  List<PodcastEpisode> episodes;

  Podcast({this.id, this.name, this.author, this.episodes});

  Map<String, dynamic> toMap() {
    var map = {
      _columnId: id,
      columnName: name,
      columnPodcastAuthor: author,
      columnPodcastImage: imageUrl,
      'episodes': episodes,
    };
    return map;
  }

  Podcast.fromMap(Map<String, dynamic> map) {
    id = map[_columnId];
    name = map[columnName];
    author = map[columnPodcastAuthor];
    imageUrl = map[columnPodcastImage];
  }

}