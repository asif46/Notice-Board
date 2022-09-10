import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notification_board/providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  SharedPreferences _storage;
  String _userID;
  var _authToken = '';

  var _usersData;

  Future<void> _getUserData() async {
    print('Here');
    final response = await http.get(
      'https://notice-board-app-2afdd-default-rtdb.firebaseio.com/usersData.json?auth=$_authToken',
    );
    print('Here');

    _usersData = json.decode(response.body);
    print(_usersData);
    print('Here');
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _authToken = Provider.of<Auth>(context).token;

      _storage = await SharedPreferences.getInstance();
      _userID = _storage.getString('comingID');
      print('DrawerID : $_userID');
      await _getUserData();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 7.0, top: 18),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 18),
                child: GestureDetector(
                  child: Text('Save', style: TextStyle(fontSize: 18)),
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      height: 110,
                      width: 180,
                      margin: EdgeInsets.only(bottom: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //color: Colors.red,
                        image: DecorationImage(
                          image: AssetImage('assets/images/profile2.png'),
                          //fit: BoxFit.cover
                        ),
                      ),
                    ),
                    Positioned(
                      top: 80,
                      right: 33.0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey,
                        ),
                        child: Center(
                          child: GestureDetector(
                              onTap: () {}, //getImage,
                              child:
                                  Icon(Icons.camera_alt, color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                TextField(
                  controller: TextEditingController(text: "Aiman Iqbal"),
                  decoration: InputDecoration(
                    labelText: 'User Name',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller:
                      TextEditingController(text: "aimaniqbal@gmail.com"),
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: TextEditingController(text: "BS(2017-2021)"),
                  decoration: InputDecoration(
                    labelText: 'Session',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
