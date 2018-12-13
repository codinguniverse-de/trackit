import 'package:flutter/material.dart';
import 'package:track_it/util/localization.dart';

class GeneralStatisticsCard extends StatelessWidget {
  final int totalPages;
  final double averagePages;
  final double totalPrice;
  final int amountBooks;

  GeneralStatisticsCard({
    @required this.totalPages,
    @required this.averagePages,
    @required this.totalPrice,
    @required this.amountBooks
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
                      Text(Localization.of(context).totalPages),
                      Text(
                        totalPages.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).averagePages),
                      Text(
                        averagePages.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
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
                      Text(Localization.of(context).totalPrice),
                      Text(
                        totalPrice.toStringAsFixed(2) + ' €',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                GridTile(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(Localization.of(context).amountBooks),
                      Text(
                        amountBooks.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24.0,
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
