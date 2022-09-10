import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/notifications.dart';
import 'notificationn_item.dart';

class NotificationsGrid extends StatelessWidget {
  final bool showFavs;

  NotificationsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final notificationsData = Provider.of<Notifications>(context);
    final notifications =
        showFavs ? notificationsData.favoriteItems : notificationsData.items;
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 10);
        },
        padding: const EdgeInsets.all(10.0),
        itemCount: notifications.length,
        itemBuilder: (ctx, i) {
          var format = new DateFormat.yMMMMd("en_us").add_jm();
          var date = format.format(DateTime.parse(notifications[i].timestamp));

          return ChangeNotifierProvider.value(
            // builder: (c) => products[i],
            value: notifications[i],
            child: NotificationnItem(date
                // products[i].id,
                // products[i].title,
                // products[i].imageUrl,
                ),
          );
        }
        /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),*/
        );
  }
}
