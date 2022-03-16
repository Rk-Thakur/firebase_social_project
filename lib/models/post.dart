import 'package:firebase_project/models/comment.dart';

class Post {
  late String title;
  late String detail;
  late String imageUrl;
  late String id;
  late String userId;
  late String imageId;
  late Like likes;
  late List<Comment> comments;
  Post({
    required this.detail,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.userId,
    required this.imageId,
    required this.likes,
    required this.comments
  });
}


class Like{
  late List username;
  late int like;

  Like({
   required this.like,
   required this.username
});

  Map<String, dynamic> toJson(){
    return {
      'username': this.username,
      'like': this.like
    };
  }

  factory Like.fromJson( Map<String, dynamic> json){
    return Like(
        like: json['like'],
        username: json['username']
    );
  }

}