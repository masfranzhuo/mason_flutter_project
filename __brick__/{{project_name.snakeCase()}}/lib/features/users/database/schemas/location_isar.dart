import 'package:isar/isar.dart';

part 'location_isar.g.dart';

@Embedded()
class LocationIsar {
  late String? street;
  late String? city;
  late String? state;
  late String? country;
  late String? timezone;

  LocationIsar({
    this.street,
    this.city,
    this.state,
    this.country,
    this.timezone,
  });

  factory LocationIsar.fromJson(Map<String, dynamic> json) => LocationIsar(
        street: json['street'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        country: json['country'] as String,
        timezone: json['timezone'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'street': street,
        'city': city,
        'state': state,
        'country': country,
        'timezone': timezone,
      };
}
