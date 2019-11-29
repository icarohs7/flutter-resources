import 'package:core_resources/core_resources.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should validate empty string", () {
    const f1 = "";
    expect(requiredValidator(errorMessage: "It's empty")(f1), "It's empty");

    const f2 = "not empty";
    expect(requiredValidator(errorMessage: "It's empty")(f2), null);
  });

  test("should validate string using minimum length", () {
    const f1 = "";
    expect(minLengthValidator(2, errorMessage: "2 chars required")(f1), "2 chars required");

    const f2 = "not empty";
    expect(minLengthValidator(5, errorMessage: "5 chars required")(f2), null);
  });

  test("should use multiple validators on string", () {
    final v = validators([
      requiredValidator(errorMessage: "can't be empty"),
      minLengthValidator(5, errorMessage: "5 characters required"),
    ]);

    expect(v(""), "can't be empty");
    expect(v("hi!"), "5 characters required");
    expect(v("omai wa mou shindeiru!"), null);
  });
}
