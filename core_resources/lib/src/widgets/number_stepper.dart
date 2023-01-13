import 'package:flutter/material.dart';

import '../../core_resources.dart';

class NumberStepper extends StatelessWidget {
  const NumberStepper(
    this.number, {
    super.key,
    required this.onChange,
    this.iconColor,
    this.increaseEnabled = true,
    this.decreaseEnabled = true,
    this.decoration,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
  });

  final int number;
  final void Function(int number, NumberStepperEvent event) onChange;
  final Color? iconColor;
  final bool increaseEnabled;
  final bool decreaseEnabled;
  final Decoration? decoration;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            color: iconColor ?? context.theme.colorScheme.primary,
            onPressed: decreaseEnabled ? () => onChange(number, NumberStepperEvent.decrease) : null,
          ),
          Text('$number'),
          IconButton(
            icon: Icon(Icons.add),
            color: iconColor ?? context.theme.colorScheme.primary,
            onPressed: increaseEnabled ? () => onChange(number, NumberStepperEvent.increase) : null,
          ),
        ],
      ),
    );
  }
}

enum NumberStepperEvent {
  increase,
  decrease,
}
