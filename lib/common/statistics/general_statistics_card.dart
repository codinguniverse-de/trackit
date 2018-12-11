import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';

class GeneralStatisticsCard extends StatelessWidget {
  final int totalPages;
  final double averagePages;
  final double totalPrice;

  GeneralStatisticsCard({
    @required this.totalPages,
    @required this.averagePages,
    @required this.totalPrice,
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
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Text(Localization.of(context).totalPages),
                Text(totalPages.toString(), style: TextStyle(fontWeight: FontWeight.w700),)
              ],
            ),
            SizedBox(height: 4.0,),
            Row(
              children: <Widget>[
                Text(Localization.of(context).averagePages),
                Text(averagePages.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.w700),)
              ],
            ),

            SizedBox(height: 4.0,),
            Row(
              children: <Widget>[
                Text(Localization.of(context).totalPrice),
                Text(totalPrice.toStringAsFixed(2) + ' €', style: TextStyle(fontWeight: FontWeight.w700),)
              ],
            ) ,
          ],
        ),
      ),
    );
  }
}
