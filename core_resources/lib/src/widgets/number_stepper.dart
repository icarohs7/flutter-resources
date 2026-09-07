import 'package:material_ui/material_ui.dart';

import '../extensions/context_extensions.dart';

class const NumberStepper(
  final int number, {
  super.key,
  required final void Function(int number, NumberStepperEvent event) onChange,
  final Color? iconColor,
  final bool increaseEnabled = true,
  final bool decreaseEnabled = true,
  final Decoration? decoration,
  final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceEvenly,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove),
            color: iconColor ?? context.theme.colorScheme.secondary,
            onPressed: decreaseEnabled ? () => onChange(number, .decrease) : null,
          ),
          Text('$number'),
          IconButton(
            icon: Icon(Icons.add),
            color: iconColor ?? context.theme.colorScheme.secondary,
            onPressed: increaseEnabled ? () => onChange(number, .increase) : null,
          ),
        ],
      ),
    );
  }
}

enum NumberStepperEvent() {
  increase,
  decrease,
}
