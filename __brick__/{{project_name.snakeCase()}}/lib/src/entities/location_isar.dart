import 'package:{{project_name.snakeCase()}}/src/entities/location.dart';
import 'package:isar/isar.dart';

part 'location_isar.g.dart';

@Collection()
class LocationIsar {
  Id? id;
  @Index(unique: true, replace: true)
  late String idString;
  late String street;
  late String city;
  late String state;
  late String country;
  late String timezone;

  LocationIsar();

  factory LocationIsar.fromLocation(Location location) {
    final locationIsar = LocationIsar()
      ..street = location.street
      ..city = location.city
      ..state = location.state
      ..country = location.country
      ..timezone = location.timezone;
    return locationIsar;
  }

  Location toLocation() {
    final location = Location(
      street: street,
      city: city,
      state: state,
      country: country,
      timezone: timezone,
    );
    return location;
  }
}
