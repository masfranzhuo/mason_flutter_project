import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toDate([String locale = 'en_US']) =>
      DateFormat('dd MMMM yyyy', locale).format(toLocal());

  String toDateTime([String locale = 'en_US']) =>
      DateFormat('dd MMMM yyyy, HH:mm', locale).format(toLocal());

  String toCompleteDateTime([String locale = 'en_US']) =>
      DateFormat('EEEE,dd MMMM yyyy, HH:mm', locale).format(toLocal());
}
