import 'package:sqflite/sqflite.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';
import 'package:track_it/data/timeseries_minutes.dart';

class PodcastDatabase {
  Database db;

  String path = 'podcasts.db';

  Future open() async {
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
          $columnListened integer,
          $columnListenedAt integer)
      ''');
    });
  }

  Future<Podcast> insertPodcast(Podcast podcast) async {
    if (db == null || !db.isOpen)
      await open();
    await db.insert(tablePodcast, podcast.toMap());
    return podcast;
  }

  Future<List<Podcast>> getPodcasts() async {
    if (db == null || !db.isOpen)
      await open();
    List<Map> maps = await db.query(tablePodcast);
    if (maps != null) {
      var podcasts = maps.map((map) => Podcast.fromMap(map)).toList();
      for (var podcast in podcasts) {
        var episodes = await getPodcastEpisodes(podcast.id);
        podcast.episodes.addAll(episodes);
        if (podcast.episodes != null && podcast.episodes.length > 0) {
          podcast.lastpub = podcast.episodes[0].publishedAt;
        }
      }
      return podcasts;
    }
    return [];
  }

  Future<bool> podcastIsAdded(int podcastId) async {
    if (db == null || !db.isOpen)
      await open();
    List<Map> maps = await db
        .query(tablePodcast, where: '$columnId = ?', whereArgs: [podcastId]);
    return maps != null && maps.length > 0;
  }

  Future<PodcastEpisode> insertEpisode(PodcastEpisode episode) async {
    if (db == null || !db.isOpen)
      await open();
    await db.insert(tableEpisode, episode.toMap());
    return episode;
  }

  Future<List<PodcastEpisode>> getPodcastEpisodes(int podcastId) async {
    if (db == null || !db.isOpen)
      await open();
    List<Map> maps = await db.query(tableEpisode,
        where: '$columnPodcastId = ?',
        whereArgs: [podcastId],
        orderBy: '$columnPublishDate DESC');
    if (maps != null) {
      return maps.map((map) => PodcastEpisode.fromMap(map)).toList();
    }
    return [];
  }

  Future updateEpisode(PodcastEpisode episode) async {
    if (db == null || !db.isOpen)
      await open();
    await db.update(
      tableEpisode,
      episode.toMap(),
      where: '$columnId = ?',
      whereArgs: [episode.id],
    );
  }

  Future<List<TimeSeriesMinutes>> getTimeSeriesMinutes(int numberOfDays) async {
    if (db == null || !db.isOpen)
      await open();
    DateTime today = DateTime.now();
    int millisPerDay = 86400000;
    int numberOfMillis = numberOfDays * millisPerDay;
    int todaysMillis = DateTime(today.year, today.month, today.day)
        .add(Duration(days: 1))
        .millisecondsSinceEpoch;
    int startMillis = todaysMillis - numberOfMillis;

    List<Map> maps = await db.query(tableEpisode,
        where: '$columnListenedAt > ? AND $columnListened = ?',
        whereArgs: [startMillis, 1]);
    List<PodcastEpisode> entries =
        maps.map((m) => PodcastEpisode.fromMap(m)).toList();

    Map<int, List<PodcastEpisode>> entriesPerDay = {};
    entries.forEach((entry) {
      DateTime day = DateTime(
          entry.listenedAt.year, entry.listenedAt.month, entry.listenedAt.day);
      if (entriesPerDay.containsKey(day.millisecondsSinceEpoch)) {
        entriesPerDay[day.millisecondsSinceEpoch].add(entry);
      } else {
        entriesPerDay[day.millisecondsSinceEpoch] = [entry];
      }
    });

    List<TimeSeriesMinutes> timeSeriesMinutes = [];
    for (var currentMillis = startMillis;
        currentMillis <= todaysMillis;
        currentMillis += millisPerDay) {
      if (entriesPerDay.containsKey(currentMillis)) {
        var sum = 0;
        entriesPerDay[currentMillis].forEach((e) {
          sum += e.length;
        });
        timeSeriesMinutes.add(TimeSeriesMinutes(
            DateTime.fromMillisecondsSinceEpoch(currentMillis),
            (sum / 60).floor()));
      } else {
        timeSeriesMinutes.add(TimeSeriesMinutes(
            DateTime.fromMillisecondsSinceEpoch(currentMillis), 0));
      }
    }

    return timeSeriesMinutes;
  }

  Future<int> getTotalTimeListened() async {
    if (db == null || !db.isOpen)
      await open();
    List<PodcastEpisode> episodes = await getAllEpisodesListened();
    int time = 0;
    episodes.forEach((e) => time += e.length);
    return time;
  }

  Future<List<PodcastEpisode>> getAllEpisodesListened() async {
    if (db == null || !db.isOpen)
      await open();
    List<Map> maps = await db.query(tableEpisode,
        where: '$columnListened = ?',
        whereArgs: [1]);

    List<PodcastEpisode> episodes = maps.map((map) => PodcastEpisode.fromMap(map)).toList();
    return episodes;
  }

  Future deletePodcast(int id) async {
    if (db == null || !db.isOpen)
      await open();
    await db.delete(tablePodcast, where: '$columnId = ?', whereArgs: [id]);
    await db.delete(tableEpisode, where: '$columnPodcastId = ?', whereArgs: [id]);
  }

  Future<bool> hasEpisode(int episodeId) async {
    if (db == null || !db.isOpen)
      await open();
    List<Map> maps = await db.query(tableEpisode, where: '$columnId = ?', whereArgs: [episodeId]);
    return maps != null && maps.length > 0;
  }
}
