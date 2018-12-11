import 'package:flutter/material.dart';
import 'package:track_it/data/podcasts/podcast_episode.dart';

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
          subtitle: Text(formatTime(episode.length)),
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

  String formatTime(int seconds) {
    double minutes = (seconds / 60);
    double hours = (minutes / 60);
    if (hours.floor() == 0) {
      return '${minutes.toStringAsFixed(0)} Min.';
    } else {
      double mins = minutes % 60;
      return '${hours.floor()} h ${mins.floor()} Min.';
    }
  }
}
