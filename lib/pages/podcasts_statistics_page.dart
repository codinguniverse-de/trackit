
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:track_it/common/statistics/podcasts_statistics_card.dart';
import 'package:track_it/data/timeseries_minutes.dart';
import 'package:track_it/model/main_model.dart';
import 'package:track_it/util/localization.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PodcastsStatistics extends StatefulWidget {

  final MainModel model;

  PodcastsStatistics(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PodcastsStatistics();
  }
}

class _PodcastsStatistics extends State<PodcastsStatistics> {
  List<charts.Series<TimeSeriesMinutes, DateTime>> _seriesList = [];
  MainModel _model;
  int _totalTime = 0;
  int _averageTime = 0;
  int _numEpisodes = 0;
  int _numPodcasts = 0;

  @override
  initState() {
    super.initState();
    _model = widget.model;
    fetchSeries();
    fetchTotalTime();
    fetchNumberEpisodes();
    fetchNumPodcasts();
  }

  @override
  void didUpdateWidget(PodcastsStatistics oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchSeries();
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
              PodcastsStatisticsCard(
                totalTime: _totalTime,
                averageTime: _averageTime,
                amountEpisodes: _numEpisodes,
                amountPodcasts: _numPodcasts,
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
    var data = await _model.getTimeSeriesMinutes(_model.statisticsDays);
    var sum = 0;
    data.forEach((d) => sum += d.minutes * 60);
    print(data.length);
    setState(() {
      _averageTime =  (sum / _model.statisticsDays).floor();
      _seriesList = [
        charts.Series<TimeSeriesMinutes, DateTime>(
          id: Localization.of(context).pages,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesMinutes sales, _) => sales.date,
          measureFn: (TimeSeriesMinutes sales, _) => sales.minutes,
          data: data,
        )
      ];
    });
  }

  void fetchTotalTime() async {
    int time = await _model.getTotalTime();
    setState(() {
      _totalTime = time;
    });
  }

  void fetchNumberEpisodes() async {
    var episodes = await _model.getAllEpisodesListened();
    setState(() {
      _numEpisodes = episodes.length;
    });
  }

  void fetchNumPodcasts() {
    var podcasts = _model.podcasts;
    setState(() {
      _numPodcasts = podcasts.length;
    });
  }
}