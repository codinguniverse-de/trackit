import 'package:flutter/material.dart';
import 'package:track_it/common/side_drawer.dart';
import 'package:track_it/model/books_model.dart';
import 'package:track_it/util/localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:track_it/data/timeseries_pages.dart';

class StatisticsPage extends StatefulWidget {
  final BooksModel model;

  StatisticsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _StatisticsPageState();
  }
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<charts.Series<TimeSeriesPages, DateTime>> _seriesList = [];
  int _days = 30;

  @override
  initState() {
    super.initState();
    fetchSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text(Localization.of(context).statistics),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            Localization.of(context).pagesPerDay,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        DropdownButton<int>(
                          items: _buildDropDownItems(),
                          onChanged: (value) {
                            setState(() {
                              _days = value;
                            });
                            fetchSeries();
                          },
                          value: _days,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300.0,
                      child: charts.TimeSeriesChart(
                        _seriesList,
                        animate: true,
                        defaultRenderer:
                            new charts.BarRendererConfig<DateTime>(),
                        domainAxis: new charts.DateTimeAxisSpec(
                          usingBarRenderer: true,
                        ),
                        defaultInteractions: false,
                        behaviors: [
                          new charts.SelectNearest(),
                          new charts.DomainHighlighter()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void fetchSeries() async {
    var data = await widget.model.getTimeSeriesPages(_days);
    print(data[0].date);
    setState(() {
      _seriesList = [
        charts.Series<TimeSeriesPages, DateTime>(
          id: Localization.of(context).pages,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesPages sales, _) => sales.date,
          measureFn: (TimeSeriesPages sales, _) => sales.pagesRead,
          data: data,
        )
      ];
    });
  }

  List<DropdownMenuItem<int>> _buildDropDownItems() {
    return [
      DropdownMenuItem<int>(
        child: Text('7' + ' ' + Localization.of(context).days),
        value: 7,
      ),
      DropdownMenuItem<int>(
        child: Text('30' + ' ' + Localization.of(context).days),
        value: 30,
      ),
      DropdownMenuItem<int>(
        child: Text('365' + ' ' + Localization.of(context).days),
        value: 365,
      ),
    ];
  }
}
