import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_notificationn_screen.dart';
import '../providers/notifications.dart';

class UserNotificationnItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserNotificationnItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            /*IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditNotificationnScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),*/
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Notifications>(context, listen: false)
                      .deleteNotificationn(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed!', textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
