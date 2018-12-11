import 'package:flutter/material.dart';
import 'package:track_it/common/podcast/podcast_list_item.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/localization.dart';

class PodcastsPage extends StatelessWidget {
  final MainModel model;

  PodcastsPage(this.model);

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
        itemCount: model.podcasts.length,
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return PodcastListItem(podcast: model.podcasts[index],);
  }
}
