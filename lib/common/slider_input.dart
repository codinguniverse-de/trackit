import 'package:flutter/material.dart';

class SliderInput extends StatefulWidget {
  final int maxValue;
  final int initialValue;
  final Function(int) onChange;

  SliderInput({
    @required this.maxValue,
    @required this.initialValue,
    this.onChange
  });

  @override
  State<StatefulWidget> createState() {
    return _SliderInputState();
  }
}

class _SliderInputState extends State<SliderInput> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Flexible(
        flex: 5,
        child: Slider(
          min: 0.0,
          max: widget.maxValue.toDouble(),
          value: _currentValue.toDouble(),
          onChanged: (double value) {
            setState(() {
              _currentValue = value.toInt();
              if (widget.onChange != null)
                widget.onChange(value.toInt());
            });
          },
        ),
      ),
      Flexible(
        flex: 1,
        child: Text(
          _currentValue.toString()
        ),
      )
    ]);
  }
}
