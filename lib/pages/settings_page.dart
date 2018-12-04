import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        }),
        title: Text(Localization.of(context).settings),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.input),
            title: Text(Localization.of(context).import),
            onTap: _importData,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(Localization.of(context).export),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }

  void _importData() async {
    var params = FlutterDocumentPickerParams(
      allowedFileExtensions: ['tidb'],
      allowedMimeType: 'application/json'
    );
    var path = await FlutterDocumentPicker.openDocument(
      params: params
    );
    print(path);
  }
}
