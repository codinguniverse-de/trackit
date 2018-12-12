import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_it/common/podcast/episode_list_item.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/time_formatter.dart';

class PodcastEpisodesList extends StatelessWidget {
  final List<PodcastEpisode> episodes;
  final MainModel model;

  PodcastEpisodesList(this.episodes, this.model);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _buildListItem(context, index);
      },
      itemCount: episodes.length,
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    var episode = episodes[index];
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