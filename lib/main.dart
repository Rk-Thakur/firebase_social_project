import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/screens/status_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black
    )
  );
  await Firebase.initializeApp();
  runApp(ProviderScope(child: Home()));
}



class Home extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatusCheck(),
    );
  }
}


class StreamPage extends StatelessWidget {


int n = 0;

  StreamController number =   StreamController<int>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: StreamBuilder(
            stream: number.stream,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Text('${snapshot.data}', style: TextStyle(fontSize: 50),);
              }
              return CircularProgressIndicator();
            }
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         number.sink.add(n++);
        },
        child: Text('add'),
      ),
    );
  }
}
