import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class DrawerWidget extends StatelessWidget {
final auth = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userData = ref.watch(currentUserProvider(auth));
      return Drawer(
        child: userData.email == '' ? Center(child: CircularProgressIndicator(),) : ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(userData.userImage),
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData.username, style: TextStyle(color: Colors.white),),
                    SizedBox(height: 90,),
                    Text(userData.email, style: TextStyle(color: Colors.white),),
                  ],
                )
            ),
          ],
        )
      );
      },
    );
  }
}
