import 'package:flutter_project/core/config/general_config.dart';
import 'package:flutter_project/features/users/database/schemas/location_isar.dart';
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
  late LocationIsar? location;

  UserIsar({
    required this.idString,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.picture,
    this.dateOfBirth,
    this.registerDate,
    this.gender,
    this.email,
    this.phone,
    this.location,
  });

  factory UserIsar.fromJson(Map<String, dynamic> json) => UserIsar(
        idString: json['id'] as String,
        title: json['title'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        picture: json['picture'] as String,
        dateOfBirth:
            DateConfig.dateTimeFromJson(json['dateOfBirth'] as String?),
        registerDate:
            DateConfig.dateTimeFromJson(json['registerDate'] as String?),
        gender: json['gender'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        location: json['location'] == null
            ? null
            : LocationIsar.fromJson(
                Map<String, dynamic>.from(json['location'] as Map),
              ),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': idString,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'picture': picture,
        'dateOfBirth': DateConfig.dateTimeToJson(dateOfBirth),
        'registerDate': DateConfig.dateTimeToJson(registerDate),
        'gender': gender,
        'email': email,
        'phone': phone,
        'location': location?.toJson(),
      };
}
