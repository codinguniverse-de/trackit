import 'package:sqflite/sqflite.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';

class PodcastDatabase {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tablePodcast (
        $columnId integer primary key,
        $columnName string,
        $columnLastUpdate integer,
        $columnPodcastImage string,
        $columnThumbUrl string,
        $columnDescription string)
      ''');
      await db.execute('''
        create table $tableEpisode (
          $columnId integer primary key,
          $columnPodcastId integer,
          $columnEpisodeTitle string,
          $columnEpisodeDescription string,
          $columnEpisodeLength integer,
          $columnPublishDate integer,
          $columnListened integer)
      ''');
    });
  }

  Future<Podcast> insertPodcast(Podcast podcast) async {
    await db.insert(tablePodcast, podcast.toMap());
    return podcast;
  }

  Future<List<Podcast>> getPodcasts() async {
    List<Map> maps = await db.query(tablePodcast);
    if (maps != null) {
      var podcasts = maps.map((map) => Podcast.fromMap(map)).toList();
      for (var podcast in podcasts) {
        var episodes = await getPodcastEpisodes(podcast.id);
        podcast.episodes.addAll(episodes);
      }
      return podcasts;
    }
    return [];
  }

  Future<bool> podcastIsAdded(int podcastId) async {
    List<Map> maps = await db
        .query(tablePodcast, where: '$columnId = ?', whereArgs: [podcastId]);
    return maps != null && maps.length > 0;
  }

  Future<PodcastEpisode> insertEpisode(PodcastEpisode episode) async {
    await db.insert(tableEpisode, episode.toMap());
    return episode;
  }

  Future<List<PodcastEpisode>> getPodcastEpisodes(int podcastId) async {
    List<Map> maps = await db.query(
      tableEpisode,
      where: '$columnPodcastId = ?',
      whereArgs: [podcastId],
      orderBy: '$columnPublishDate DESC'
    );
    if (maps != null) {
      return maps.map((map) => PodcastEpisode.fromMap(map)).toList();
    }
    return [];
  }

  Future updateEpisode(PodcastEpisode episode) async {
    await db.update(tableEpisode, episode.toMap());
  }
}
