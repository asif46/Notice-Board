import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notifications.dart';
import '../widgets/user_notification_item.dart';
import '../widgets/app_drawer.dart';
import 'edit_notificationn_screen.dart';

class UserNotificationsScreen extends StatelessWidget {
  static const routeName = '/user-notifications';

  Future<void> _refreshNotifications(BuildContext context) async {
    await Provider.of<Notifications>(context, listen: false)
        .fetchAndSetNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Your Notifications'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditNotificationnScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshNotifications(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshNotifications(context),
                    child: Consumer<Notifications>(
                      builder: (ctx, notificationsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: notificationsData.items.length,
                              itemBuilder: (_, i) => Column(
                                    children: [
                                      UserNotificationnItem(
                                        notificationsData.items[i].id,
                                        notificationsData.items[i].title,
                                        notificationsData.items[i].imageUrl,
                                      ),
                                      Divider(),
                                    ],
                                  ),
                            ),
                          ),
                    ),
                  ),
      ),
    );
  }
}
