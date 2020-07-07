import 'dart:convert';
import 'package:flutter_photo_firebase/photo.dart';
import 'package:http/http.dart' as http;

class RestService {
  static final RestService _instance = RestService._constructor();
  factory RestService() {
    return _instance;
  }

  RestService._constructor();

  // Change the baseUrl based on your laptop's IP address.
  // Make sure you use IP address, not 'localhost'
  // Don't use https for local JSON-Server
  // Make sure you specify the port number 3000

  static const String baseUrl = 'http://192.168.137.1:3000';

  Future get(String endpoint) async {
    final response = await http.get('$baseUrl/$endpoint');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future post(String endpoint, {dynamic data}) async {
    final response = await http.post('$baseUrl/$endpoint',
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future patch(String endpoint, {dynamic data}) async {
    final response = await http.patch('$baseUrl/$endpoint',
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future delete(String endpoint) async {
    final response = await http.delete('$baseUrl/$endpoint');

    if (response.statusCode == 200) {
      return;
    }
    throw response;
  }

  Future<List<Photo>> getPhotos() async {
    final json = await get('photos');
    List<Photo> photos = List<Photo>();

    for (int i = 0; i < json.length; i++) {
      photos.add(Photo.fromJson(json[i]));
    }

    return photos;
  }

  Future<Photo> updatePhoto({int id, Photo photo, bool isliked}) async {
    photo = updateLike(photo: photo, isLiked: isliked);
    final json = await patch('photos/$id',
        data: isliked ? {'like': photo.like} : {'dislike': photo.dislike});
    return Photo.fromJson(json);
  }

  Photo updateLike({Photo photo, bool isLiked}) {
    if (isLiked) {
      photo.like++;
    } else {
      photo.dislike++;
    }
    return photo;
  }
}

final restService = RestService();
