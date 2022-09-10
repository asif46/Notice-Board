import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification_board/providers/users.dart';
import 'package:notification_board/screens/login.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
//import './screens/cart_screen.dart';
import 'screens/notifications_overview_screen.dart';
import 'screens/notificationn_detail_screen.dart';
import 'providers/notifications.dart';
//import './providers/cart.dart';
//import './providers/orders.dart';
import './providers/auth.dart';
//import './screens/orders_screen.dart';
import 'screens/user_notifications_screen.dart';
import 'screens/edit_notificationn_screen.dart';
import './screens/auth_screen.dart';
import './screens/signup.dart';
import './helpers/custom_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Notifications>(
          create: (ctx) => Notifications(),
          update: (ctx, auth, previousNotifications) => previousNotifications
            ..recieveToken(
              auth,
              previousNotifications == null ? [] : previousNotifications.items,
            ),
        ), 
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Notice Board App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            //scaffoldBackgroundColor: const Color(0xFFEFEFEF),
            //primaryColor: Colors.black,
            primarySwatch: Colors.grey,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth
              ? NotificationsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : LogInScreen(),
                ),
          routes: {
            NotificationnDetailScreen.routeName: (ctx) =>
                NotificationnDetailScreen(),
            UserNotificationsScreen.routeName: (ctx) =>
                UserNotificationsScreen(),
            EditNotificationnScreen.routeName: (ctx) =>
                EditNotificationnScreen(),
            //AppDrawer.routeName: (ctx) => AppDrawer(),
          },
        ),
      ),
    );
  }
}
