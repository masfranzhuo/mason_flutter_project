import 'dart:convert';

import 'package:{{project_name.snakeCase()}}/core/config/date_config.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/location.dart';
import 'package:{{project_name.snakeCase()}}/src/entities/user.dart';

import '../../fixtures/fixtures_reader.dart';

// User and List of Users
final userJson = Map<String, dynamic>.from(
  json.decode(fixture('fixtures/users/single.json')),
);
final user = User(
  id: '60d0fe4f5311236168a109ca',
  title: 'ms',
  firstName: 'Sara',
  lastName: 'Andersen',
  picture: 'https://randomuser.me/api/portraits/women/58.jpg',
  gender: 'female',
  email: 'sara.andersen@example.com',
  phone: '92694011',
  location: Location(
    street: '9614, SÃ¸ndermarksvej',
    city: 'Kongsvinger',
    state: 'Nordjylland',
    country: 'Denmark',
    timezone: '-9:00',
  ),
  dateOfBirth: DateConfig.dateTimeFromJson('1996-04-30T19:26:49.610Z'),
  registerDate: DateConfig.dateTimeFromJson('2021-06-21T21:02:07.374Z'),
);

final List<dynamic> usersJson = List<dynamic>.from(
  json.decode(fixture('fixtures/users/collection.json')),
).toList();
final List<User> users = usersJson
    .map((item) => User.fromJson(Map<String, dynamic>.from(item)))
    .toList();
