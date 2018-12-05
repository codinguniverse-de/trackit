import 'package:flutter/material.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/util/localization.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(Localization.of(context).statistics),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: SizedBox(
              height: 100.0,
            ),
          )
        ],
      ),
    );
  }
}
