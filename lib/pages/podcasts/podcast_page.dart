import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/podcast/episode_list_item.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/time_formatter.dart';

class PodcastPage extends StatelessWidget {
  final Podcast podcast;

  PodcastPage(this.podcast);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, model) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  title: Text(podcast.name),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background:
                        Image.network(podcast.imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ];
            },
            body: ListView.builder(
              itemBuilder: (context, index) {
                return _buildListItem(context, index, model);
              },
              itemCount: podcast.episodes.length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, int index, MainModel model) {
    var episode = podcast.episodes[index];
    return EpisodeListItem(
      episode,
      onTap: () {
        showEpisodeInfo(context, episode);
      },
      onListenedPress: () {
        model.toggleListened(episode);
      },
    );
  }

  void showEpisodeInfo(BuildContext context, PodcastEpisode episode) {
    showDialog(
      context: context,
      builder: (context) {
        var dateFormat = DateFormat.yMMMd(
            Localizations.localeOf(context).languageCode.toLowerCase());
        return AlertDialog(
          title: Text(episode.title),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      dateFormat.format(episode.publishedAt),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      TimeFormatter().formatTime(episode.length),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                Text(episode.description),
              ],
            ),
          ),
        );
      },
    );
  }
}
