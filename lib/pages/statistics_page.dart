import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/pages/books_statistics_page.dart';
import 'package:track_it/pages/podcasts_statistics_page.dart';
import 'package:track_it/util/localization.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ScopedModelDescendant<MainModel>(
        builder: (context, widget, model) {
          return Scaffold(
            drawer: SideDrawer(),
            appBar: AppBar(
              title: Text(Localization.of(context).statistics),
//              actions: <Widget>[
//                DropdownButton<int>(
//                  style: Theme.of(context).accentTextTheme.title,
//
//                  items: _buildDropDownItems(context),
//                  onChanged: (value) {
//                    model.statisticsDays = value;
//                  },
//                  value: model.statisticsDays,
//                ),
//              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: Localization.of(context).booksDrawerItem,
                  ),
                  Tab(
                    text: Localization.of(context).podcasts,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                BooksStatistics(model),
                PodcastsStatistics(model),
              ],
            ),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<int>> _buildDropDownItems(BuildContext context) {
    var paint = Paint();
    paint.color = Theme.of(context).primaryColorDark;
    return [
      DropdownMenuItem<int>(
        child: Text(
          '7' + ' ' + Localization.of(context).days,
        ),
        value: 7,
      ),
      DropdownMenuItem<int>(
        child: Text(
          '30' + ' ' + Localization.of(context).days,
        ),
        value: 30,
      ),
      DropdownMenuItem<int>(
        child: Text(
          '365' + ' ' + Localization.of(context).days,
        ),
        value: 365,
      ),
    ];
  }
}
