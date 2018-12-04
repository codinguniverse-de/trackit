
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
            onTap:() => Navigator.of(context).pushReplacementNamed('/'),
          )
        ],
      ),
    );
  }
}