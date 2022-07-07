import 'package:flutter/material.dart';
import 'package:flutter_project/src/entities/user.dart';

class UserCardWidget extends StatelessWidget {
  final User user;
  final void Function(BuildContext) onTap;

  const UserCardWidget({Key? key, required this.user, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipOval(child: Image.network(user.picture)),
        title: Text(user.firstName),
        subtitle: Text(user.lastName),
        trailing: IconButton(
          key: Key('user-card-widget-icon-button-key-${user.id}'),
          icon: Icon(
            Icons.navigate_next,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => onTap(context),
        ),
      ),
    );
  }
}
