import 'package:flutter/material.dart';
import 'package:track_it/data/podcasts/podcast.dart';

class PodcastPage extends StatelessWidget {
  final Podcast podcast;

  PodcastPage(this.podcast);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Image.network(podcast.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemBuilder: _buildListItem,
          itemCount: podcast.episodes.length,
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    var episode = podcast.episodes[index];
    return ListTile(
      title: Text(episode.title),
    );
  }
}
