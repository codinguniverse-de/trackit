import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/podcast/podcast_list_item.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/podcasts/podcast_page.dart';
import 'package:track_it/util/localization.dart';

class PodcastsPage extends StatefulWidget {
  final MainModel model;

  PodcastsPage(this.model);

  @override
  State createState() {
    return _PodcastsPageState();
  }
}

class _PodcastsPageState extends State<PodcastsPage> {
  @override
  void initState() {
    super.initState();
    widget.model.fetchPodcasts();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (_, widget, model) {
      return Scaffold(
        drawer: SideDrawer(),
        appBar: AppBar(
          title: Text(
            Localization.of(context).podcasts,
          ),
        ),
        body: buildListView(model),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed('/addpodcast');
          },
        ),
      );
    });
  }

  Widget buildListView(MainModel model) {
    if (model.podcastsLoading)
      return Center(child: CircularProgressIndicator(),);

    if (model.podcasts.length == 0)
      return Center(child: Text(Localization.of(context).addPodcast));

    return ListView.builder(
        itemBuilder: _buildItem,
        itemCount: model.podcasts.length,
      );
  }

  Widget _buildItem(BuildContext context, int index) {
    var podcast = widget.model.podcasts[index];
    return PodcastListItem(
      podcast: podcast,
      onTap: () {
        podcast.hasNewEpisode = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastPage(podcast),
          ),
        );
      },
    );
  }
}
