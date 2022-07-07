import 'package:flutter/material.dart';
import 'package:{{project_name}}.snakeCase()}}/core/config/date_config.dart';
import 'package:{{project_name}}.snakeCase()}}/core/services/translator.dart';
import 'package:{{project_name}}.snakeCase()}}/src/entities/user.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

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
              child: ClipOval(child: Image.network(user.picture)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.title')}: ${user.title}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.name')}: ${user.firstName} ${user.lastName}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.email')}: ${user.email}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.gender')}: ${user.gender}',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.dateOfBirth')}: ${DateConfig.dateFormat.format(user.dateOfBirth!)},',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 0),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.joinFrom')}: ${DateConfig.dateFormat.format(user.registerDate!)},',
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.r, 8.r, 16.r, 16.r),
              child: Text(
                '${GetIt.I<TranslatorService>().translate(context, 'model.user.address')}: ${user.location?.country}, ${user.location?.state}, ${user.location?.city}, ${user.location?.street}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
