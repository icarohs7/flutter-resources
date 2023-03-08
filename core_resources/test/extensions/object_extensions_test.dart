import 'package:core_resources/core_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should convert object to material state property', () {
    const color = Colors.red;
    final materialStateProperty = color.materialProperty;
    expect(materialStateProperty.resolve({}), color);
  });

  test('apply extension', () {
    //arrange
    const value = 10;
    //act
    final result = value.apply((v) => v * 3);
    //assert
    expect(result, 30);
  });
}
