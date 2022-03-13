import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/models/post.dart';
import 'package:firebase_project/providers/crud_provider.dart';
import 'package:firebase_project/providers/image_provider.dart';
import 'package:firebase_project/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';




class EditPage extends StatelessWidget {

  final Post post;
  EditPage(this.post);

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
                              child: Text('Update Post', style: TextStyle(fontSize: 25),)),
                          SizedBox(height: 25,),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: titleController..text = post.title,
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
                                child:  db.image == null ? Image.network(post.imageUrl, fit: BoxFit.cover,)  : Image.file(File(db.image!.path), fit: BoxFit.cover,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              maxLines: 2,
                              controller: detailController..text = post.detail,
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

                                if(db.image == null) {
                                  final response = await ref.read(crudProvider).updatePost(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      postId: post.id,
                                    imageId: post.imageId,
                                    image:  null
                                  );
                                  if(response == 'success'){
                                    Navigator.of(context).pop();
                                  }
                                }else{
                                  final response = await ref.read(crudProvider).updatePost(
                                      title: titleController.text.trim(),
                                      detail: detailController.text.trim(),
                                      postId: post.id,
                                      imageId: post.imageId,
                                      image:  db.image
                                  );
                                  if(response == 'success'){
                                    Navigator.of(context).pop();
                                  }

                                }


                              },
                              child: Text('update Post'),
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
