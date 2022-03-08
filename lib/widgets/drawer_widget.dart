import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class DrawerWidget extends StatelessWidget {
final auth = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
        //  Text(auth.providerData!.toString())
        ],
      ),
    );
  }
}
