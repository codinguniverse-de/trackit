
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/statistics/general_statistics_card.dart';
import 'package:track_it/data/timeseries_pages.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BooksStatistics extends StatefulWidget {

  final MainModel model;

  BooksStatistics(this.model);

  @override
  State<StatefulWidget> createState() {
    return _BookStatisticsState();
  }
}

class _BookStatisticsState extends State<BooksStatistics> {
  List<charts.Series<TimeSeriesPages, DateTime>> _seriesList = [];
  int _totalPages = 0;
  double _averagePages = 0.0;
  double _totalPrice = 0.0;
  MainModel _model;

  @override
  initState() {
    super.initState();
    _model = widget.model;
    fetchSeries();
    fetchTotalPages();
    fetchTotalPrice();
    fetchAveragePages();
  }

  @override
  void didUpdateWidget(BooksStatistics oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchSeries();
    fetchAveragePages();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, widget, model) {
        _model = model;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              GeneralStatisticsCard(
                totalPages: _totalPages,
                averagePages: _averagePages,
                totalPrice: _totalPrice,
                amountBooks: _model.books.length,
              ),
              Card(
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
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 300.0,
                        child: charts.TimeSeriesChart(
                          _seriesList,
                          animate: true,
                          defaultRenderer:
                          charts.BarRendererConfig<DateTime>(),
                          domainAxis: new charts.DateTimeAxisSpec(
                            usingBarRenderer: true,
                          ),
                          defaultInteractions: true,
                          behaviors: [
                            charts.SelectNearest(),
                            charts.DomainHighlighter()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void fetchSeries() async {
    var data = await _model.getTimeSeriesPages(_model.statisticsDays);
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

  void fetchTotalPages() async {
    int pages = await _model.getTotalPages();
    setState(() {
      _totalPages = pages;
    });
  }

  void fetchTotalPrice() async {
    double price = await _model.getTotalPrice();
    setState(() {
      _totalPrice = price;
    });
  }

  void fetchAveragePages() async {
    double pages = await _model.getAveragePerDay(_model.statisticsDays);
    setState(() {
      _averagePages = pages;
    });
  }
}