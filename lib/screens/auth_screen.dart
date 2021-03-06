
import 'dart:io';

import 'package:firebase_project/providers/auth_provider.dart';
import 'package:firebase_project/providers/image_provider.dart';
import 'package:firebase_project/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';




class AuthScreen extends StatelessWidget {

  final userNameController = TextEditingController();
  final mailController = TextEditingController();
  final passController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final isLogin = ref.watch(loginProvider);
              final db = ref.watch(imageProvider);
              return SingleChildScrollView(

                child: Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(isLogin ? 'Login Form' : 'Sign Up Form', style: TextStyle(fontSize: 25),)),
                        SizedBox(height: 25,),
                     if(!isLogin)   Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              hintText: 'Username'
                            ),
                          ),
                        ),
                        if(!isLogin) InkWell(
                          onTap: (){
                            ref.read(imageProvider).getImage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              height: 140,
                              child:  db.image == null ? Center(child: Text('please select an image'),) : Image.file(File(db.image!.path), fit: BoxFit.cover,),
                            ),
                          ),
                        ),
                          Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: mailController,
                            decoration: InputDecoration(
                                hintText: 'Email'
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            controller: passController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: 'Password'
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        Container(
                          child: ElevatedButton(
                            onPressed: ()async {
                              _form.currentState!.save();
                              FocusScope.of(context).unfocus();
                         if(isLogin){
                         await  ref.read(logSignProvider).Login(email: mailController.text.trim(), password: passController.text.trim());
                         }else{
                             if(db.image == null){
                          Get.defaultDialog(title: 'please provide an image',content: Text('image must be select')  );
                             }else{
                             await  ref.read(logSignProvider).signUp(
                                   userName: userNameController.text.trim(),
                                   email: mailController.text.trim(), password: passController.text.trim(),
                                   image: db.image!
                               );
                             }

                         }


                            },
                            child: Text('Submit'),
                          ),
                        ),
                    Row(
                      children: [
                        Text(isLogin ? 'Don\t have an account': 'Already have an account'),
                        TextButton(onPressed: (){
                          ref.read(loginProvider.notifier).toggle();
                        }, child: Text(isLogin ? 'SignUp': 'Login'))
                      ],
                    ),

                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        )
    );
  }
}
