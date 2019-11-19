extension DoubleExtensions on double {
  String asCurrency() => "R\$ " + toStringAsFixed(2).replaceAll(".", ",");
}
