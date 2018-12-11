import 'package:flutter/material.dart';
import 'package:track_it/data/podcasts/podcast.dart';

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
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: _buildImage()),
          title: Text(podcast.name),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
