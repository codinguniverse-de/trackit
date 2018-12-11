import 'package:flutter/material.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';

class PodcastDetailPage extends StatelessWidget {
  final PodcastScheme podcast;

  PodcastDetailPage(this.podcast);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background:
                      Image.network(podcast.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      podcast.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      podcast.subtitle,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      podcast.description,
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ],
                ),
              )
          ),
        ));
  }
}
