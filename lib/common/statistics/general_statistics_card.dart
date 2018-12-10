import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';

class GeneralStatisticsCard extends StatelessWidget {
  final int totalPages;
  final double averagePages;

  GeneralStatisticsCard({
    @required this.totalPages,
    @required this.averagePages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Localization.of(context).generalData,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(Localization.of(context).totalPages + totalPages.toString()),
            Text(Localization.of(context).averagePages +
                averagePages.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}
