import 'package:flutter/material.dart';
import 'package:track_it/common/podcast/podcast_list_item.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/main_model.dart';
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
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(
          Localization.of(context).podcasts,
        ),
      ),
      body: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: widget.model.podcasts.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/addpodcast');
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return PodcastListItem(
      podcast: widget.model.podcasts[index],
    );
  }
}
