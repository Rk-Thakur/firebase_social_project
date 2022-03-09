


class UserC{

  late String email;
  late String userImage;
  late String username;
  late String userId;

  UserC({
   required this.email,
   required this.userImage,
   required this.username,
    required this.userId
});

  factory  UserC.fromJson(Map<String, dynamic> json){
    return UserC(
        email: json['email'],
        userImage: json['userImage'],
        username: json['username'],
      userId:  json['userId']
    );
  }



}