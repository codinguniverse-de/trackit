import 'package:flutter/material.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';
import 'package:track_it/util/time_formatter.dart';

class EpisodeListItem extends StatelessWidget {
  final PodcastEpisode episode;
  final Function onListenedPress;
  final Function onTap;

  EpisodeListItem(this.episode, {this.onListenedPress, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: onTap,
          title: Text(
            episode.title,
          ),
          subtitle: Text(TimeFormatter().formatTime(context, episode.length)),
          trailing: buildIconButton(context),
        ),
        Divider(),
      ],
    );
  }

  Widget buildIconButton(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: episode.listened
            ? Theme.of(context).accentColor
            : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(Icons.check),
        color: episode.listened
            ? Theme.of(context).accentIconTheme.color
            : Theme.of(context).iconTheme.color,
        onPressed: onListenedPress,
      ),
    );
  }


}
