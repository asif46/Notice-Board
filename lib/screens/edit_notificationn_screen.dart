//import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notification_board/providers/auth.dart';


import 'package:provider/provider.dart';

import '../providers/notificationn.dart';
import '../providers/notifications.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

//import './notifications_overview_screen.dart';

class EditNotificationnScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditNotificationnScreenState createState() =>
      _EditNotificationnScreenState();
}

class _EditNotificationnScreenState extends State<EditNotificationnScreen> {
  //final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String _notType;

  //String _noticeId = '';

  File _image;

  String _comingFirebaseURL = '';

  


  var _editedNotificationn = Notificationn(
    id: null,
    title: '',
    timestamp: '',
    noticetype: '',
    session: '',
    //price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'timestamp': '',
    'noticetype': '',
    'session': '',
    //'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    _image = File(pickedFile.path);
    print('here');
    print('Path : ${pickedFile.path}');
    setState(() {});
  }
/*
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }
  Future _uploadPost(File image) async {
    setState(() {
      _isLoading = true;
    });
    DatabaseReference reference = await FirebaseDatabase.instance.reference();
    StorageReference ref = await FirebaseStorage.instance.ref().child("Blog_images").child(image.uri.toString() + ".jpg");
    StorageUploadTask uploadTask = ref.putFile(image);
    String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    /*_noticeId = reference.child("Blogs").push().key;
    Map data = {
      'image': downloadUrl,
      'title': title,
      'desc': description, 
    };*/
  }*/

  Future<String> uploadImage() async{
    print('here 1');

    String token = _image.path.split('/').last;
    print('Image Name : $token');

    print('here 2');

  final ref = FirebaseStorage.instance.ref().child('notifications').child( '$token');
    print('here 3');

  await ref.putFile(_image);
    print('here 4');

  return  await ref.getDownloadURL();

  }


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final notificationnId =
          ModalRoute.of(context).settings.arguments as String;
      if (notificationnId != null) {
        _editedNotificationn =
            Provider.of<Notifications>(context, listen: false)
                .findById(notificationnId);
        _initValues = {
          'title': _editedNotificationn.title,
          'description': _editedNotificationn.description,
          'timeStamp': _editedNotificationn.timestamp,
          'noticetype': _editedNotificationn.noticetype,
          'session': _editedNotificationn.session,
          //'price': _editedNotificationn.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': _editedNotificationn.imageUrl,
        };
        _imageUrlController.text = _editedNotificationn.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    //_priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedNotificationn.id != null) {
      await Provider.of<Notifications>(context, listen: false)
          .updateNotificationn(_editedNotificationn.id, _editedNotificationn);
    } else {
      try {

        _comingFirebaseURL =  await uploadImage();
        
        _editedNotificationn.imageUrl = _comingFirebaseURL;

        print('Save Time URL : ${_editedNotificationn.imageUrl}');

        await Provider.of<Notifications>(context, listen: false)
            .addNotificationn(_editedNotificationn);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Edit Notification'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 1),
                      ),
                      child: _image == null
                          ? Center(child: Text('No Image Selected', style: TextStyle(color: Colors.white),))
                          : Container(
                              child: Image.file(_image),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text(
                        _image == null ? 'Select Image' : 'Update Image',
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        style: TextStyle(color: Colors.yellow),
                        cursorColor: Colors.yellow,
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.yellow[100],
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.yellow[100],
                            ),
                          ),
                          labelText: 'Title',
                          labelStyle: TextStyle(
                              color: Colors.yellow[100], fontSize: 16.0),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedNotificationn = Notificationn(
                              title: value,
                              timestamp: DateTime.now().toIso8601String(),
                              noticetype: _notType,
                              session: _editedNotificationn.session,
                              //price: _editedNotificationn.price,
                              description: _editedNotificationn.description,
                              imageUrl: _comingFirebaseURL,
                              id: _editedNotificationn.id,
                              isFavorite: _editedNotificationn.isFavorite);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: TextFormField(
                        style: TextStyle(color: Colors.yellow),
                        cursorColor: Colors.yellow,
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.yellow[100],
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.yellow[100],
                            ),
                          ),
                          labelText: 'Description',
                          labelStyle: TextStyle(
                              color: Colors.yellow[100], fontSize: 16.0),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        //textInputAction: TextInputAction.done,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedNotificationn = Notificationn(
                            title: _editedNotificationn.title,
                            timestamp: DateTime.now().toIso8601String(),
                            noticetype: _notType,
                            session: _editedNotificationn.session,

                            //price: _editedNotificationn.price,
                            description: value,
                            imageUrl: _comingFirebaseURL,
                            id: _editedNotificationn.id,
                            isFavorite: _editedNotificationn.isFavorite,
                          );
                        },
                      ),
                    ),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Notice Type:",
                  style: TextStyle(fontSize: 16, color: Colors.yellow[100])),
                  Spacer(),
                        DropdownButton(
                          style: TextStyle(color: Colors.yellow,),dropdownColor: Colors.grey,
                          items: ['Normal', 'Important', 'Prioritized']
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          underline: Container(),
                          value: _notType,
                          onChanged: (value) {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              _notType = value;
                            });

                            print('$_notType : $value');
                          },
                          
                        ),
                      ],
                    ),
                    

                    //SessionWidget(),
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            style: TextStyle(color: Colors.yellow),
                            cursorColor: Colors.yellow,
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                              labelStyle: TextStyle(
                                  color: Colors.yellow[100], fontSize: 16.0),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedNotificationn = Notificationn(
                              timestamp: DateTime.now().toIso8601String(),

                                title: _editedNotificationn.title,
                                //price: _editedNotificationn.price,
                                description: _editedNotificationn.description,
                                imageUrl: value,
                                id: _editedNotificationn.id,
                                isFavorite: _editedNotificationn.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),*/
                  ],
                ),
              ),
            ),
    );
  }
}
