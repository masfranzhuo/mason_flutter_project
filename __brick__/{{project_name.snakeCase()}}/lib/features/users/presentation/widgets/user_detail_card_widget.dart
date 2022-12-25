import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/core/extensions/date_time_extension.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';
import 'package:{{project_name.snakeCase()}}/generated/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailCardWidget extends StatelessWidget {
  final User user;

  const UserDetailCardWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
              child: ClipOval(
                child: Image.network(
                  user.picture,
                  errorBuilder: (context, obj, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_title.tr()}: ${user.title}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_name.tr()}: ${user.firstName} ${user.lastName}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_email.tr()}: ${user.email}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_gender.tr()}: ${user.gender}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_dateOfBirth.tr()}: ${user.dateOfBirth!.toDate()},',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${LocaleKeys.model_user_joinFrom.tr()}: ${user.registerDate!.toDate()},',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 16.r),
              child: Text(
                '${LocaleKeys.model_user_address.tr()}: ${user.location?.country}, ${user.location?.state}, ${user.location?.city}, ${user.location?.street}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
