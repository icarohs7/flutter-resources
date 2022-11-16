import 'package:flutter/foundation.dart';

import '../maskedinput_resources.dart';

const FieldMasks = _FieldMasks();

@immutable
class _FieldMasks {
  const _FieldMasks();

  MaskTextInputFormatter cpf() => MaskTextInputFormatter(mask: '###.###.###-##');

  MaskTextInputFormatter cnpj() => MaskTextInputFormatter(mask: '##.###.###/####-##');

  MaskTextInputFormatter cellphone() => MaskTextInputFormatter(mask: '(##) #####-####');

  MaskTextInputFormatter phone() => MaskTextInputFormatter(mask: '(##) ####-####');

  MaskTextInputFormatter zipCode() => MaskTextInputFormatter(mask: '#####-###');
}
