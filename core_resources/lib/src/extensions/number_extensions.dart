extension StringToNumberExtensions on String {
  ///Removes all non-digit characters of the string
  ///and returns the resulting sequence
  String onlyNumbers() => replaceAll(RegExp(r'[^0-9]'), '');

  ///Removes all non-digit characters of the string
  ///and returns the resulting sequence parsed to int
  int digits() => int.parse(onlyNumbers());
}

extension DoubleExtensions on double {
  ///Convert the given value to a currency representation
  String asCurrency() => 'R\$ ' + toStringAsFixed(2).replaceAll('.', ',');

  ///Convert the given value to a string representation,
  ///removing trailing zeros in the decimal part
  String toStringTrimmingDecimals({int precision = 5}) {
    return toStringAsFixed(precision).replaceAll(RegExp(r'([.]*0+)(?!.*\d)'), '');
  }
}
