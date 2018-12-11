import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/podcast/episode_list_item.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/model/main_model.dart';

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
      onTap: () {},
      onListenedPress: () {
        model.toggleListened(episode);
      },
    );
  }
}
