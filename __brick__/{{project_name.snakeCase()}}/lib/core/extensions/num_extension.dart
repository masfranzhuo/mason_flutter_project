import 'package:intl/intl.dart';

extension NumExtension on num {
  String toNumber([String locale = 'en_US']) =>
      NumberFormat('#,##0.00', locale).format(this);

  String toCurrency([String prefix = '\$', String locale = 'en_US']) =>
      '$prefix${NumberFormat('#,##0.00', locale).format(this)}';
}
