import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/providers/auth_provider.dart';
import 'package:firebase_project/providers/post_provider.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:firebase_project/widgets/create_page.dart';
import 'package:firebase_project/widgets/drawer_widget.dart';
import 'package:firebase_project/widgets/user_show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(userProvider);
        final postData = ref.watch(postStream);
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                UserPage(userData),
            postData.when(
                data: (data){
                  return ListView.builder(
                    shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          height: 300,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(data[index].title, style: TextStyle(fontSize: 17),),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(data[index].imageUrl,
                                    height: 250,
                                    width: double.infinity,
                                    fit: BoxFit.cover,),
                                ),
                              ],
                            )
                        );
                      });
                },
                error: (err, stack) => Text('$err'),
                loading: () => Center(child: CircularProgressIndicator(
                  color: Colors.purple,
                ))),

                ],
              ),
            )
        );
      }
    );
  }
}
