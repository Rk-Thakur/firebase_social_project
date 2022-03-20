import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_project/providers/auth_provider.dart';
import 'package:firebase_project/providers/crud_provider.dart';
import 'package:firebase_project/providers/post_provider.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:firebase_project/screens/detail_screen.dart';
import 'package:firebase_project/widgets/create_page.dart';
import 'package:firebase_project/widgets/drawer_widget.dart';
import 'package:firebase_project/widgets/edit_page.dart';
import 'package:firebase_project/widgets/user_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';



class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final auth = FirebaseAuth.instance.currentUser!.uid;


  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

getToken();

    super.initState();
  }

  getToken() async{
   final token =  await FirebaseMessaging.instance.getToken();
   print(token);
  }

  @override
  Widget build(BuildContext context) {

    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(userProvider);
        final postData = ref.watch(postStream);
        final currentUser = ref.watch(currentUserProvider(auth));
        return Scaffold(
          drawer: DrawerWidget(),
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Main Screen'),
              actions: [
                TextButton(onPressed: (){
                  Get.to(() => CreatePage(), transition: Transition.leftToRight);
                }, child: Text('create', style: TextStyle(color: Colors.white),)),
                TextButton(onPressed: () {
              ref.read(logSignProvider).LogOut();
                },
                    child: Text(
                      'SignOut', style: TextStyle(color: Colors.white),))
              ],
            ),
            body: Column(
              children: [
              UserPage(userData),
            postData.when(
              data: (data){
                return Container(
                  height: 630,
                  child: ListView.builder(
                    shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          height:auth != data[index].userId ?  370 : 370,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data[index].title, style: TextStyle(fontSize: 17),),
                                if(auth == data[index].userId) IconButton(
                                    onPressed: (){
                                  Get.defaultDialog(
                                    title: 'update or remove post',
                                    content: Text('customize post'),
                                    actions: [
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                      Get.to(() => EditPage(data[index]), transition: Transition.leftToRight);
                                        }, child: Icon(Icons.edit)),
                                        TextButton(
                                            onPressed: () async{
                                          Navigator.of(context).pop();
                                       await  ref.read(crudProvider).removePost(postId: data[index].id, imageId: data[index].imageId);
                                        }, child: Icon(Icons.delete)),
                                    ]
                                  );
                                    }, icon: Icon(Icons.more_horiz_sharp))
                                  ],
                                ),
                                InkWell(
                                  onTap: (){
                                    Get.to(() => DetailScreen(data[index], currentUser), transition: Transition.leftToRight);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(data[index].imageUrl,
                                      height: 270,
                                      width: double.infinity,
                                      fit: BoxFit.cover,),
                                  ),
                                ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Spacer(),
                                    Text(data[index].likes.like == 0 ? '' :'Likes ${data[index].likes.like}'),
                                    if(auth != data[index].userId)    IconButton(
                                      alignment: Alignment.topCenter,
                                        onPressed: (){
                                        if(data[index].likes.username.contains(currentUser.username)){
                                          Get.showSnackbar(GetSnackBar(
                                            duration: Duration(seconds: 1),
                                            title: 'you have already like this post',
                                            message: 'some',
                                          ));
                                        }else{
                                          Like newLike = Like(
                                              like: data[index].likes.like + 1,
                                              username: [...data[index].likes.username, currentUser.username]
                                          );
                                          ref.read(crudProvider).addLike(postId: data[index].id, like: newLike);
                                        }
                                    }, icon: Icon(Icons.thumb_up))
                                  ],
                                )
                              ],
                            )
                        );
                      }),
                );
              },
              error: (err, stack) => Text('$err'),
              loading: () => Center(child: CircularProgressIndicator(
                color: Colors.purple,
              ))),

              ],
            )
        );
      }
    );
  }
}
