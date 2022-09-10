import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/notifications.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:loading_dialog/loading_dialog.dart';

class NotificationnDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/notificationn-detail';

  @override
  Widget build(BuildContext context) {
    final notificationnId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedNotificationn = Provider.of<Notifications>(
      context,
      listen: false,
    ).findById(notificationnId);
    return Scaffold(
      // appBar: AppBar
      // (
      //   title: Text('Notification Detail', ),],
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedNotificationn.title),
              
              background: Hero(

                tag: loadedNotificationn.id,
                child: Stack(
                  children: [
                     Container(
                       width: double.infinity,
                       child: Image.network(
                    loadedNotificationn.imageUrl,
                    fit: BoxFit.fill,
                  ),
                     ),                     Positioned(top: 120,right: 120,child: IconButton(icon: Icon(Icons.download_sharp, color: Colors.white, size: 30,),onPressed: ()async{
                       try {
                      showDialog(context: context, builder: (ctx)=>AlertDialog());
                      // Saved with this method.
                      var imageId = await ImageDownloader.downloadImage(
                         loadedNotificationn.imageUrl);
                         print('id : $imageId');
                      if (imageId == null) {
                        return;
                      }
                      // Below is a method of obtaining saved image information.
                      var fileName = await ImageDownloader.findName(imageId);
                      var path = await ImageDownloader.findPath(imageId);
                      var size = await ImageDownloader.findByteSize(imageId);
                      var mimeType =
                          await ImageDownloader.findMimeType(imageId);
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Image downloaded.');
                    } on PlatformException catch (error) {
                      print(error);
                    }
                     },))
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedNotificationn.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
          /*

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.grey),
            child: Center(
              child: GestureDetector(
                  onTap: () async {
                    try {
                      showDialog(context: context, builder: (ctx)=>AlertDialog());
                      // Saved with this method.
                      var imageId = await ImageDownloader.downloadImage(
                         loadedNotificationn.imageUrl);
                      if (imageId == null) {
                        return;
                      }
                      // Below is a method of obtaining saved image information.
                      var fileName = await ImageDownloader.findName(imageId);
                      var path = await ImageDownloader.findPath(imageId);
                      var size = await ImageDownloader.findByteSize(imageId);
                      var mimeType =
                          await ImageDownloader.findMimeType(imageId);
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Image downloaded.');
                    } on PlatformException catch (error) {
                      print(error);
                    }
                  },
                  child: Icon(
                    Icons.file_download,
                    color: Colors.black,
                  ),
                  ),
            ),
          ),
          */
        ],
      ),
    );
  }
}
