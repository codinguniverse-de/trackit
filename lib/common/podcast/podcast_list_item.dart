import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/util/localization.dart';

class PodcastListItem extends StatelessWidget {
  final Podcast podcast;
  final Function onTap;

  PodcastListItem({
    @required this.podcast,
    this.onTap,
  });

  Widget _buildImage() {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: podcast.imageUrl == null
              ? AssetImage('assets/podcast_icon.png')
              : NetworkImage(podcast.imageUrl),
        ),
        borderRadius: BorderRadius.circular(40.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat.yMMMMd(
        Localizations.localeOf(context).languageCode.toLowerCase());
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: _buildImage()),
          title: Text(podcast.name),
          subtitle: Text(Localization.of(context).lastUpdate + format.format(podcast.lastpub)),
          trailing: podcast.hasNewEpisode ? Icon(Icons.fiber_new) : null,
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
