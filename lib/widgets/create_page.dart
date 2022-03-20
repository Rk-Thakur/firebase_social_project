import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_project/providers/image_provider.dart';
import 'package:firebase_project/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';




class CreatePage extends StatelessWidget {

  final titleController = TextEditingController();
  final detailController = TextEditingController();


  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
        body: SafeArea(
          child: Consumer(
              builder: (context, ref, child) {
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
                              child: Text('create Post', style: TextStyle(fontSize: 25),)),
                          SizedBox(height: 25,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintText: 'Title'
                              ),
                            ),
                          ),
                           InkWell(
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
                              maxLines: 2,
                              controller: detailController,
                              decoration: InputDecoration(
                                  hintText: 'Detail'
                              ),
                            ),
                          ),

                          SizedBox(height: 15,),
                          Container(
                            child: ElevatedButton(
                              onPressed: ()async {
                                _form.currentState!.save();
                                FocusScope.of(context).unfocus();
                                if(db.image == null) {
                                  Get.defaultDialog(
                                      title: 'please provide an image',
                                      content: Text('image must be select'));
                                }else{
                                  Like newLike = Like(
                                      like: 0,
                                      username:[]);
                               final response = await   ref.read(postCrudProvider).addPost(
                                   title: titleController.text.trim(),
                                   detail: detailController.text.trim(),
                                   image: db.image!,
                                   userId: auth,
                                 likes: newLike
                               );
                               if(response == 'success'){
                                 Navigator.of(context).pop();
                               }
                                }


                              },
                              child: Text('add Post'),
                            ),
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
