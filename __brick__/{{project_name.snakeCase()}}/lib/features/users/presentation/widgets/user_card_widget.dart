import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/features/users/models/user.dart';

class UserCardWidget extends StatelessWidget {
  final User user;
  final void Function(BuildContext) onTap;

  const UserCardWidget({Key? key, required this.user, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            user.picture,
            errorBuilder: (context, obj, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
        ),
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
