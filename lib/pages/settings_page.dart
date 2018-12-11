import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/localization.dart';


class SettingsPage extends StatelessWidget {
  Function(Brightness) themeChanged;

  SettingsPage({this.themeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        }),
        title: Text(Localization.of(context).settings),
      ),
      body:
      ScopedModelDescendant<MainModel>(
        builder: (context, widget, model) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onTap: () => _exportData(context, model),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Theme', style: Theme.of(context).textTheme.subhead),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Light'),
                  Radio<Brightness>(
                    value: Brightness.light,
                    onChanged: themeChanged,
                    groupValue: model.theme,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Dark'),
                  Radio<Brightness>(
                    value: Brightness.dark,
                    onChanged: themeChanged,
                    groupValue: model.theme,
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }

  void _importData() async {
//    var params = FlutterDocumentPickerParams(
//      allowedFileExtensions: ['tidb'],
//      allowedMimeType: 'application/json'
//    );
//    var path = await FlutterDocumentPicker.openDocument(
//      params: params
//    );
//    if (path == null)
//      return;

  }

  void _exportData(BuildContext context, MainModel model) async {
//    var path = await getApplicationDocumentsDirectory();
//    if (path == null)
//      return;
//    var file = File(path);
//    var allEntries = await model.getAllEntries();
//    Map<String, dynamic> data = {
//      'books': model.books,
//      'entries': allEntries,
//    };
//    await file.writeAsString(json.encode(data));
//
//    Scaffold.of(context).showSnackBar(SnackBar(content: Text(Localization.of(context).exportSuccess)));
  }
}
