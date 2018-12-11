import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/podcast/podcast_list_item.dart';
import 'package:track_it/model/main_model.dart';
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
                      Expanded(child: TextField(
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
              Expanded(child: ListView.builder(itemBuilder: _buildItem, itemCount: model.searchResults.length,))
            ],
          ),
        );
      },
    );
  }

  void submitSearch() {
    print(_searchTerm);
  }

  Widget _buildItem(BuildContext context, int index) {
    return PodcastListItem(podcast: _model.searchResults[index],);
  }
}
