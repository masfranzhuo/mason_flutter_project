import 'package:flutter_project/core/base/model/model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location extends AppModel with _$Location {
  factory Location({
    required String street,
    required String city,
    required String state,
    required String country,
    required String timezone,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
