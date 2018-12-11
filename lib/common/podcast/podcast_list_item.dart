import 'package:flutter/material.dart';
import 'package:track_it/data/book/book.dart';
import 'package:track_it/data/podcasts/podcast.dart';

class PodcastListItem extends StatelessWidget {
  final Podcast podcast;
  final Function onTap;

  PodcastListItem({
    @required this.podcast,
    this.onTap,
  });

  Widget _buildImage() {
    return podcast.imageUrl == null
        ? Image.asset(
            'assets/podcast_icon.png',
            fit: BoxFit.fitWidth,
            width: 80.0,
            height: 80.0,
          )
        : FadeInImage(
            width: 80.0,
            height: 80.0,
            placeholder: AssetImage('assets/book_icon.png'),
            image: NetworkImage(podcast.imageUrl),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: _buildImage()),
          title: Text(podcast.name),
          subtitle: Text(podcast.author),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
