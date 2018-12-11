import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/data/api/schemes/podcast_scheme.dart';
import 'package:track_it/data/podcasts/podcast.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/podcasts/podcast_detail_page.dart';
import 'package:track_it/util/localization.dart';

class AddPodcastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPodcastPageState();
  }
}

class _AddPodcastPageState extends State<AddPodcastPage> {
  String _searchTerm = '';
  MainModel _model;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (_, widget, model) {
        _model = model;
        return Scaffold(
          appBar: AppBar(
            title: Text(Localization.of(context).addPodcast),
          ),
          body: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchTerm = value;
                          });
                        },
                        onSubmitted: (_) {
                          submitSearch();
                        },
                      )),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          submitSearch();
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              buildList(model)
            ],
          ),
        );
      },
    );
  }

  Widget buildList(MainModel model) {
    if (_model.podcastsLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Expanded(
        child: ListView.builder(
      itemBuilder: _buildItem,
      itemCount: model.searchResults.length,
    ));
  }

  void submitSearch() {
    _model.searchPodcasts(_searchTerm);
  }

  Widget _buildItem(BuildContext context, int index) {
    var podcast = _model.searchResults[index];
    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              image: DecorationImage(image: NetworkImage(podcast.thumbUrl)),
            ),
          ),
          title: Text(podcast.title),
          trailing: IconButton(icon: Icon(Icons.add), onPressed: () {
            onItemAdd(podcast);
          }),
          onTap: () => onItemTap(podcast),
        ),
        Divider(),
      ],
    );
  }

  void onItemTap(PodcastScheme podcast) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PodcastDetailPage(podcast)));
  }

  void onItemAdd(PodcastScheme scheme) {
    var podcast = Podcast.fromScheme(scheme);
    _model.addPodcast(podcast);
  }
}
