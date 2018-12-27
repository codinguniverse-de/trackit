
import 'package:track_it/data/podcasts/podcast_episode.dart';

final String tablePodcast = 'podcasts';
final String columnId = 'id';
final String columnName = 'title';
final String columnDescription = 'description';
final String columnPodcastImage = 'imgURL';
final String columnLastUpdate = 'lastpub';
final String columnThumbUrl = 'thumbImageURL';


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
    if (map[columnId] is String) {
      map[columnId] = int.parse(map[columnId]);
    }
    id = map[columnId];
    name = map[columnName];
    if (map[columnLastUpdate] is String) {
      lastpub = DateTime.parse(map[columnLastUpdate]);
    } else {
      lastpub = DateTime.fromMillisecondsSinceEpoch(map[columnLastUpdate]);
    }
    thumbUrl = map[columnThumbUrl];
    description = map[columnDescription];
    imageUrl = map[columnPodcastImage];
    if (map["episodes"] != null) {
      episodes = List();
      for (var episode in map["episodes"]) {
        episodes.add(PodcastEpisode.fromMap(episode));
      }
    }
  }


}