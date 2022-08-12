import 'package:{{project_name.snakeCase()}}/src/entities/location_isar.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';
import 'package:isar/isar.dart';

part 'user_isar.g.dart';

@Collection()
class UserIsar {
  Id? id;
  @Index(unique: true, replace: true)
  late String idString;
  late String title;
  late String firstName;
  late String lastName;
  late String picture;
  late DateTime? dateOfBirth;
  late DateTime? registerDate;
  late String? gender;
  late String? email;
  late String? phone;
  final location = IsarLink<LocationIsar>();

  UserIsar();

  factory UserIsar.fromUser(User user) {
    UserIsar userIsar = UserIsar()
      ..idString = user.id
      ..title = user.title
      ..firstName = user.firstName
      ..lastName = user.lastName
      ..picture = user.picture
      ..dateOfBirth = user.dateOfBirth
      ..registerDate = user.registerDate
      ..gender = user.gender
      ..email = user.email
      ..phone = user.phone;

    final location = user.location;
    if (location != null) {
      final locationIsar = LocationIsar.fromLocation(location)
        ..idString = user.id;
      userIsar = userIsar..location.value = locationIsar;
    }

    return userIsar;
  }

  User toUser() {
    User user = User(
      id: idString,
      title: title,
      firstName: firstName,
      lastName: lastName,
      picture: picture,
      dateOfBirth: dateOfBirth,
      registerDate: registerDate,
      gender: gender,
      email: email,
      phone: phone,
    );

    final locationIsar = location.value;
    if (locationIsar != null) {
      final location = locationIsar.toLocation();
      user = user.copyWith(location: location);
    }

    return user;
  }
}
