import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';
import 'package:track_it/util/time_formatter.dart';

class PodcastsStatisticsCard extends StatelessWidget {
  final int totalTime;
  final int averageTime;
  final int amountPodcasts;
  final int amountEpisodes;

  PodcastsStatisticsCard({
    @required this.totalTime,
    @required this.averageTime,
    @required this.amountPodcasts,
    @required this.amountEpisodes
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 200.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GridTile(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).totalTime),
                      Text(
                        TimeFormatter().formatTime(context, totalTime),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26.0,
                        ),
                      ),
                    ],
                  ),
                ),
                GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).averageTime),
                      Text(
                        TimeFormatter().formatTime(context, averageTime),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).amountPodcasts),
                      Text(
                        amountPodcasts.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26.0,
                        ),
                      ),
                    ],
                  ),
                ),
                GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).amountEpisodes),
                      Text(
                        amountEpisodes.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 26.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
