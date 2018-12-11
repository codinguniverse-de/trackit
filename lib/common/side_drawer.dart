import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text(Localization.of(context).booksDrawerItem),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text(Localization.of(context).statistics),
            onTap: () => Navigator.of(context).pushReplacementNamed('/statistics'),
          ),
          SizedBox(
            height: 40.0,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(Localization.of(context).settings),
            onTap: () => Navigator.of(context).pushReplacementNamed('/settings'),
          )
        ],
      ),
    );
  }
}
