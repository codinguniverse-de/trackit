
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';

final String tablePodcast = 'podcasts';
final String columnId = 'id';
final String columnName = 'name';
final String columnDescription = 'description';
final String columnPodcastImage = 'imageUrl';
final String columnLastUpdate = 'lastpub';
final String columnThumbUrl = 'thumburl';


class Podcast {
  int id;
  String imageUrl;
  String name;
  DateTime lastpub;
  String description;
  String thumbUrl;
  bool hasNewEpisode = false;

  List<PodcastEpisode> episodes = [];


  Podcast({this.id, this.imageUrl, this.name, this.lastpub, this.description,
      this.thumbUrl, this.episodes});

  Map<String, dynamic> toMap() {
    var map = {
      columnId: id,
      columnName: name,
      columnLastUpdate: lastpub.millisecondsSinceEpoch,
      columnPodcastImage: imageUrl,
      columnThumbUrl: thumbUrl,
      columnDescription: description
    };
    return map;
  }

  Podcast.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    lastpub = DateTime.fromMillisecondsSinceEpoch(map[columnLastUpdate]);
    thumbUrl = map[columnThumbUrl];
    description = map[columnDescription];
    imageUrl = map[columnPodcastImage];
  }

  Podcast.fromScheme(PodcastScheme scheme) {
    id = scheme.podcastId;
    name = scheme.title;
    lastpub = scheme.lastPub;
    thumbUrl = scheme.thumbUrl;
    description = scheme.description;
    imageUrl = scheme.imageUrl;
  }

}