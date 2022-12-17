import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> testMask(MaskTextInputFormatter formatter, String input, String expected) async {
    final actual =
        formatter.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: input)).text;
    expect(actual, expected);
  }

  test('FieldMasks.cpf', () async {
    await testMask(FieldMasks.cpf(), '12312312312', '123.123.123-12');
  });

  test('FieldMasks.cnpj', () async {
    await testMask(FieldMasks.cnpj(), '12312312312312', '12.312.312/3123-12');
  });

  test('FieldMasks.cellphone', () async {
    await testMask(FieldMasks.cellphone(), '11912341234', '(11) 91234-1234');
  });

  test('FieldMasks.phone', () async {
    await testMask(FieldMasks.phone(), '1123123412', '(11) 2312-3412');
  });

  test('FieldMasks.zipCode', () async {
    await testMask(FieldMasks.zipCode(), '12345678', '12345-678');
  });
}
