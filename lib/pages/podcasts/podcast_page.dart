import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/podcasts/podcast_episodes_list.dart';
import 'package:track_it/util/localization.dart';

class PodcastPage extends StatelessWidget {
  final Podcast podcast;

  PodcastPage(this.podcast);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, model) {
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    title: Text(podcast.name),
                    bottom: TabBar(tabs: [
                      Tab(
                        text: Localization.of(context).details,
                      ),
                      Tab(
                        text: Localization.of(context).episodes,
                      ),
                    ]),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background:
                          Image.network(podcast.imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(podcast.name,
                              style: Theme.of(context).textTheme.title),
                          SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            podcast.description,
                            style: Theme.of(context).textTheme.body1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  PodcastEpisodesList(podcast.episodes, model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
