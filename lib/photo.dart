class Photo {
  int id;
  String photoURL;
  String thumbURL;
  int like;
  int dislike;

  Photo({this.id, this.photoURL, this.thumbURL, this.like, this.dislike});

  Photo.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            photoURL: json['photoUrl'],
            thumbURL: json['thumbUrl'],
            like: json['like'],
            dislike: json['dislike']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'photoUrl': photoURL,
        'thumbUrl': thumbURL,
        'like': like,
        'dislike': dislike
      };
}
