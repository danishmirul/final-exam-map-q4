import 'package:flutter/material.dart';
import 'package:flutter_photo_firebase/photo_screen.dart';

import 'photo.dart';
import 'rest_service.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  Future<List<Photo>> _futureData;
  List<Photo> photos;

  void likeDislike(Photo photo, bool like) {
    setState(() {
      restService.updatePhoto(id: photo.id, photo: photo, isliked: like);
    });
  }

  @override
  void initState() {
    super.initState();
    _futureData = restService.getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            photos = snapshot.data;

            return _buildMainScreen();
          }

          return _buildFetchingDataScreen();
        });
  }

  Widget _buildMainScreen() {
    return Scaffold(
      body: ListView.separated(
        itemCount: photos.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.blueGrey,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: InkWell(
              onTap: null,
              child: Container(
                height: 90,
                child: Image.network(
                  '${photos[index].thumbURL}',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: SizedBox(
                height: 100,
                child: InkWell(
                  onTap: () {},
                )),
            trailing: _buildThumbButtons(photos[index]),
          );
        },
      ),
    );
  }

  Widget _buildThumbButtons([Photo photo = null]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('${photo.like}',
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        IconButton(
            icon: Icon(
              Icons.thumb_up,
              color: Colors.green,
            ),
            onPressed: () => likeDislike(photo, true)),
        IconButton(
            icon: Icon(
              Icons.thumb_down,
              color: Colors.red,
            ),
            onPressed: () => likeDislike(photo, false)),
        Text('${photo.dislike}',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Scaffold _buildFetchingDataScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Fetching data in progress'),
          ],
        ),
      ),
    );
  }
}
