import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tuple.freezed.dart';

@freezed
abstract class Tuple2<A, B> with _$Tuple2 {
  const factory Tuple2(A value1, B value2) = _Tuple2;
}
