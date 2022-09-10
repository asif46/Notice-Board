import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notification_board/providers/users.dart';
import 'package:notification_board/screens/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../screens/orders_screen.dart';
import '../screens/user_notifications_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';
import 'package:http/http.dart'as http;

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isInit = true;
  bool _isLoading = true;
  SharedPreferences _storage;
  String _userID;
  var _authToken='';

  var _usersData;

  Future<void> _getUserData() async {
    print('Here');
    final response = await http.get('https://notice-board-app-2afdd-default-rtdb.firebaseio.com/usersData.json?auth=$_authToken', );
    print('Here');

    _usersData = json.decode(response.body);
    print(_usersData);
    print('Here');

  }

  @override
    void didChangeDependencies() async {
      if(_isInit) {
        _authToken=Provider.of<Auth>(context).token;

        _storage = await SharedPreferences.getInstance();
        _userID = _storage.getString('comingID');
        print('DrawerID : $_userID');
        await _getUserData();
        setState(() {
                  _isLoading = false;
                });

      }_isInit = false;
      super.didChangeDependencies();
    }

  @override
  Widget build(BuildContext context) {

    // final _userData = Provider.of<UsersData>(context).userData;

    // print(_userData);


    //final auth = Provider.of<Auth>(context, listen: false);
    return _isLoading ? Drawer() : Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 5.0, color: Colors.grey),
                right: BorderSide(width: 5.0, color: Colors.grey),
                bottom: BorderSide(width: 5.0, color: Colors.grey),
              ),
              color: Theme.of(context).primaryColor,
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                     (_usersData[_userID]['photoUrl'] != '' ||  _usersData[_userID]['photoUrl']!=null)?Image.network(
                      _usersData[_userID]['photoUrl'],
                      height: 40,
                      width: 40, 
                    ):
                    Image.asset(
                      'assets/images/a.jpg',
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 5),
                    Column(
                      children: <Widget>[
                        Text(
                          'Notice Board',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'See what u need',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                        SizedBox(height: 25),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Welcome Dear ${_usersData[_userID]['userName']}',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                Text('${_usersData[_userID]['email']}',
                    style: TextStyle(fontSize: 15, color: Colors.white60)),
              ],
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
            child: Row(
              children: <Widget>[
                SizedBox(width: 25),
                Icon(Icons.camera_alt, color: Colors.black54),
                SizedBox(width: 25),
                Text('My Profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: Row(
              children: <Widget>[
                SizedBox(width: 25),
                Icon(Icons.camera_alt, color: Colors.black54),
                SizedBox(width: 25),
                Text('Notices',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserNotificationsScreen.routeName);
            },
            child: Row(
              children: <Widget>[
                SizedBox(width: 25),
                Icon(Icons.camera_alt, color: Colors.black54),
                SizedBox(width: 25),
                Text('Manage Notices',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
            child: Row(
              children: <Widget>[
                SizedBox(width: 25),
                Icon(Icons.camera_alt, color: Colors.black54),
                SizedBox(width: 25),
                Text('Logout',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
