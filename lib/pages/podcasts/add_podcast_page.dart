import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
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
  List _results = List();

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
                          decoration: InputDecoration(
                            labelText: Localization.of(context).startTyping,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchTerm = value;
                            });
                          },
                        ),
                      ),
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
    if (_searchTerm.length < 8) {
      return Container();
    }
    var query = """
      query {
        searchPodcast(term: \"$_searchTerm\") {
          id
          title
          imgURL
          thumbImageURL
          language
          lastpoll
          lastpub
          description
          subtitle
          episodes {
            id
            title
            podcast_id
            imgURL
            pubdate
            duration
            description
          }
        }
      }
    """
        .replaceAll("\n", " ");

    return Expanded(
        child: Query(
      query,
      pollInterval: 5,
      builder: ({bool loading, var data, Exception error}) {
        if (error != null) {
          return Text(error.toString());
        }
        if (loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _results = data['searchPodcast'];
        return ListView.builder(
          itemBuilder: _buildItem,
          itemCount: _results.length,
        );
      },
    ));
  }

  Widget _buildItem(BuildContext context, int index) {
    var podcast = _results[index];
    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              image: DecorationImage(
                  image: NetworkImage(podcast["thumbImageURL"])),
            ),
          ),
          title: Text(podcast["title"]),
          trailing: buildAddButton(podcast, context),
          onTap: () => onItemTap(podcast),
        ),
        Divider(),
      ],
    );
  }

  Widget buildAddButton(Map podcast, BuildContext context) {
    if (podcast["loadingAdd"] != null && podcast["loadingAdd"]) {
      return CircularProgressIndicator();
    }

    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        onItemAdd(podcast);
      },
    );
  }

  void onItemTap(Map podcast) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PodcastDetailPage(podcast)));
  }

  void onItemAdd(Map scheme) {
    var podcast = Podcast.fromMap(scheme);
    _model.addPodcast(podcast);
  }
}
