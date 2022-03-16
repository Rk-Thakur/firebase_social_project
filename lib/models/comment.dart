


class Comment{

  late String username;
  late String imageUrl;
  late String comment;

  Comment({
    required this.imageUrl,
    required this.username,
    required this.comment
});

 factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
        imageUrl: json['imageUrl'],
        username: json['username'],
        comment: json['comment']
    );
  }


  Map<String, dynamic> toJson(){
   return {
     'imageUrl': this.imageUrl,
     'username': this.username,
     'comment': this.comment
   };
  }



}