import 'package:firebase_project/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class MainScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purple,
              title: Text('Main Screen'),
              actions: [
                TextButton(onPressed: () {
              ref.read(logSignProvider).LogOut();
                },
                    child: Text(
                      'SignOut', style: TextStyle(color: Colors.white),))
              ],
            ),
            body: Container(

            )
        );
      }
    );
  }
}
