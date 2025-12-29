import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validators', () {
    final v = validators([
      requiredValidator(errorMessage: 'can\'t be empty'),
      minLengthValidator(5, errorMessage: '5 characters required'),
    ]);

    expect(v(''), 'can\'t be empty');
    expect(v('hi!'), '5 characters required');
    expect(v('omai wa mou shindeiru!'), null);
  });

  test('requiredValidator', () {
    const f1 = '';
    expect(requiredValidator(errorMessage: 'It\'s empty')(f1), 'It\'s empty');

    const f2 = 'not empty';
    expect(requiredValidator(errorMessage: 'It\'s empty')(f2), null);
  });

  test('minLengthValidator', () {
    const f1 = '';
    expect(minLengthValidator(2, errorMessage: '2 chars required')(f1), '2 chars required');

    const f2 = 'not empty';
    expect(minLengthValidator(5, errorMessage: '5 chars required')(f2), null);

    const f3 = 'hi';
    expect(minLengthValidator(5, errorMessage: '5 chars required')(f3), '5 chars required');

    const f4 = 'default';
    expect(minLengthValidator(15)(f4), 'Mínimo de 15 caracteres requiridos');
  });

  test('emailValidator', () {
    const f1 = '';
    expect(emailValidator(errorMessage: 'Invalid email')(f1), 'Invalid email');

    const f2 = 'not an email';
    expect(emailValidator(errorMessage: 'Invalid email')(f2), 'Invalid email');

    const f3 = 'test@test.com';
    expect(emailValidator(errorMessage: 'Invalid email')(f3), null);

    const f4 = '';
    expect(emailValidator(errorMessage: 'Invalid email', allowBlank: true)(f4), null);
  });

  test('phoneValidator', () {
    const f1 = '';
    expect(phoneValidator(errorMessage: 'Invalid phone')(f1), 'Invalid phone');

    const f2 = '123456789';
    expect(phoneValidator(errorMessage: 'Invalid phone')(f2), 'Invalid phone');

    const f3 = '12345678901';
    expect(phoneValidator(errorMessage: 'Invalid phone')(f3), null);

    const f4 = '12341234';
    expect(phoneValidator(requiredLength: 8, errorMessage: 'Invalid phone')(f4), null);
  });

  test('cpfValidator', () {
    const f1 = '';
    expect(cpfValidator(errorMessage: 'Invalid cpf')(f1), 'Invalid cpf');

    const f2 = '123456789';
    expect(cpfValidator(errorMessage: 'Invalid cpf')(f2), 'Invalid cpf');

    const f3 = '12345678901';
    expect(cpfValidator(errorMessage: 'Invalid cpf')(f3), null);
  });

  test('optionalCpfValidator', () {
    const f1 = '';
    expect(optionalCpfValidator(errorMessage: 'Invalid cpf')(f1), null);

    const f2 = '123456789';
    expect(optionalCpfValidator(errorMessage: 'Invalid cpf')(f2), 'Invalid cpf');

    const f3 = '12345678901';
    expect(optionalCpfValidator(errorMessage: 'Invalid cpf')(f3), null);
  });

  test('cnpjValidator', () {
    const f1 = '';
    expect(cnpjValidator(errorMessage: 'Invalid cnpj')(f1), 'Invalid cnpj');

    const f2 = '123456789';
    expect(cnpjValidator(errorMessage: 'Invalid cnpj')(f2), 'Invalid cnpj');

    const f3 = '12345678901234';
    expect(cnpjValidator(errorMessage: 'Invalid cnpj')(f3), null);
  });

  test('zipValidator', () {
    const f1 = '';
    expect(zipValidator(errorMessage: 'Invalid zip')(f1), 'Invalid zip');

    const f2 = '123456789';
    expect(zipValidator(errorMessage: 'Invalid zip')(f2), 'Invalid zip');

    const f3 = '12345123';
    expect(zipValidator(errorMessage: 'Invalid zip')(f3), null);
  });

  test('userValidator', () {
    const f1 = '';
    expect(userValidator(errorMessage: 'Invalid user')(f1), 'Invalid user');

    const f2 = '1user';
    expect(userValidator(errorMessage: 'Invalid user')(f2), 'Invalid user');

    const f3 = 'User';
    expect(userValidator(errorMessage: 'Invalid user')(f3), null);

    const f4 = 'user';
    expect(userValidator(errorMessage: 'Invalid user')(f4), null);

    const f5 = 'u';
    expect(userValidator(errorMessage: 'Invalid user')(f5), null);

    const f6 = '1';
    expect(userValidator(errorMessage: 'Invalid user')(f6), 'Invalid user');

    const f7 = 'uSer';
    expect(userValidator(errorMessage: 'Invalid user')(f7), null);
  });

  test('validIntValidator', () {
    const f1 = '';
    expect(validIntValidator(errorMessage: 'Invalid int')(f1), 'Invalid int');

    const f2 = '1.1';
    expect(validIntValidator(errorMessage: 'Invalid int')(f2), 'Invalid int');

    const f3 = '1';
    expect(validIntValidator(errorMessage: 'Invalid int')(f3), null);

    const f4 = '0number';
    expect(validIntValidator(errorMessage: 'Invalid int')(f4), 'Invalid int');
  });

  test('validDoubleValidator', () {
    const f1 = '';
    expect(validDoubleValidator(errorMessage: 'Invalid double')(f1), 'Invalid double');

    const f2 = '1.1.1';
    expect(validDoubleValidator(errorMessage: 'Invalid double')(f2), 'Invalid double');

    const f3 = '1.1';
    expect(validDoubleValidator(errorMessage: 'Invalid double')(f3), null);

    const f4 = '0number';
    expect(validDoubleValidator(errorMessage: 'Invalid double')(f4), 'Invalid double');

    const f5 = '1';
    expect(validDoubleValidator(errorMessage: 'Invalid double')(f5), null);
  });
}
