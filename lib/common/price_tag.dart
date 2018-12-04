import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceTag extends StatelessWidget {

  final double value;

  PriceTag({@required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Theme.of(context).accentColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0),
        child: Text(
          '${format(value)}€',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0
          ),
        ),
      ),
    );
  }

  String format(num n) {
    final f = NumberFormat('###.00');
    final s = f.format(n);
    return s.endsWith('00') ? s.substring(0, s.length - 3) : s;
  }
}