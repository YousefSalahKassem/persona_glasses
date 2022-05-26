import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkable/linkable.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Constants/constants_color.dart';
import '../Services/firebase_operations.dart';

class PostOptions with ChangeNotifier{

  ConstantColors constantColors=ConstantColors();
  TextEditingController commentController=TextEditingController();
  TextEditingController editCommentController=TextEditingController();
  TextEditingController addCommentController=TextEditingController();
  late String imageTimePosted;
  String get getImageTimePosted=>imageTimePosted;

  Future addLike(BuildContext context,String postId,String subDocId,String type)async{
    return  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      FirebaseFirestore.instance.collection(type).doc(postId).collection('likes').doc(subDocId).set(
          {
            'likes':FieldValue.increment(1),
            'username':FirebaseAuth.instance.currentUser!.displayName,
            'useruid':FirebaseAuth.instance.currentUser!.uid,
            'userimage':FirebaseAuth.instance.currentUser!.photoURL,
            'useremail':FirebaseAuth.instance.currentUser!.email,
            'time':Timestamp.now()
          });});

  }

  Future addComment(String postId,String comment,BuildContext context,String type)async{
    if(comment.isEmpty){}
    else{
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').doc(comment).set(
            {
              'comment':comment,
              'username':FirebaseAuth.instance.currentUser!.displayName,
              'useruid':FirebaseAuth.instance.currentUser!.uid,
              'userimage':FirebaseAuth.instance.currentUser!.photoURL,
              'useremail':FirebaseAuth.instance.currentUser!.email,
              'time':Timestamp.now()
            });
      });
    }}

  showLikes(BuildContext context,String postId,String type){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height*.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4,
                color: constantColors.whiteColor,
              ),
            ),
            Container(
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: constantColors.whiteColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text('Likes',style: TextStyle(color: constantColors.blueColor,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.4,
              width: 400,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(type).doc(postId).collection('likes').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      return  ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot snapshot) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot['userimage']),
                            ),
                            title: Text(snapshot['username'],style: TextStyle(color: constantColors.blueColor,fontWeight: FontWeight.bold,fontSize: 16),),
                            subtitle: Text(snapshot['useremail'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 12),),
                          );
                        }).toList(),
                      );
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }

  Future addLikeOnComment(BuildContext context,DocumentSnapshot documentSnapshot,String postId,String type)async{
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').doc(documentSnapshot.id).collection('likeoncomment').doc(FirebaseAuth.instance.currentUser!.uid).set({
        'username':FirebaseAuth.instance.currentUser!.displayName,
        'useruid':FirebaseAuth.instance.currentUser!.uid,
        'userimage':FirebaseAuth.instance.currentUser!.photoURL,
        'useremail':FirebaseAuth.instance.currentUser!.email,
        'time':Timestamp.now(),
        'likes':FieldValue.increment(1),

      });
    });
  }

  showLikesOnComment(BuildContext context,String postId,DocumentSnapshot documentSnapshot,String type){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: MediaQuery.of(context).size.height*.5,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4,
                color: constantColors.whiteColor,
              ),
            ),
            Container(
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: constantColors.whiteColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text('Likes',style: TextStyle(color: constantColors.blueColor,fontSize: 16,fontWeight: FontWeight.bold),),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.2,
              width: 400,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').doc(documentSnapshot.id).collection('likeoncomment').snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot snapshot) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(snapshot['userimage']),
                            ),
                            title: Text(snapshot['username'],style: TextStyle(color: constantColors.blueColor,fontWeight: FontWeight.bold,fontSize: 16),),
                            subtitle: Text(snapshot['useremail'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 12),),
                            trailing: FirebaseAuth.instance.currentUser!.uid==snapshot['useruid']?Container(width: 0,height: 0,):MaterialButton(onPressed: () {  },color: constantColors.blueColor,
                              child: Text('Follow',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),),),
                          );
                        }).toList(),
                      );
                    }
                  }),
            ),
          ],
        ),
      );
    });
  }

  Future addCommentInComment (BuildContext context,String postId,DocumentSnapshot documentSnapshot,String type)async{
    if(addCommentController.text.isEmpty){}
    else{
      return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
        FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').doc(documentSnapshot.id).collection('commentoncomment').doc().set({
          'username':FirebaseAuth.instance.currentUser!.displayName,
          'useruid':FirebaseAuth.instance.currentUser!.uid,
          'userimage':FirebaseAuth.instance.currentUser!.photoURL,
          'useremail':FirebaseAuth.instance.currentUser!.email,
          'time':Timestamp.now(),
          'comment':addCommentController.text,
        });
      });
    }}

  showCommentInComment(BuildContext context,DocumentSnapshot documentSnapshot,String postId,String name,String image,String type){
    return showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 850.0),
                    child: Divider(
                      thickness: 1,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Wrap(
                    children: [ Container(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(radius: 15,backgroundColor: Colors.transparent,backgroundImage: NetworkImage(image),),
                                SizedBox(width:10 ,),
                                Text(name,style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(onPressed: (){},
                                  icon: Icon(Icons.arrow_forward_ios_outlined,color: constantColors.blueColor,size: 12,)),
                              SizedBox(width: MediaQuery.of(context).size.width*.7,child: Linkable(text:documentSnapshot['comment'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),textColor: constantColors.whiteColor,)),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              height: 8,
                              width: 350,
                              child: Divider(
                                color: constantColors.greyColor,
                              ),
                            ),
                          )
                        ],
                      ) ,
                    ),],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*.4,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').doc(documentSnapshot.id).collection('commentoncomment').orderBy('time').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else{
                            return  ListView(
                              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                                return Wrap(
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: CircleAvatar(
                                                  backgroundColor: constantColors.darkColor,
                                                  radius: 15,
                                                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Container(
                                                  child: Text(documentSnapshot['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              children: [
                                                IconButton(onPressed: (){},
                                                    icon: Icon(Icons.arrow_forward_ios_outlined,color: constantColors.blueColor,size: 12,)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Linkable(text:documentSnapshot['comment'],style: TextStyle(color: constantColors.whiteColor,fontSize: 15),textColor: constantColors.whiteColor,),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(color: constantColors.darkColor.withOpacity(.2),),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        }),
                  ),
                  Container(
                    width: 400,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*.7,
                          height: 20,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Add Comment',
                              hintStyle: TextStyle(
                                  color: constantColors.greyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            controller: addCommentController,
                            style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),
                          ),
                        ),
                        FloatingActionButton(onPressed: (){
                          addCommentInComment(context, postId, documentSnapshot, type).whenComplete(() {
                            addCommentController.clear();
                          });

                        },
                          child: Icon(FontAwesomeIcons.comment,color: constantColors.whiteColor,),
                          backgroundColor: constantColors.blueColor,)
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color:constantColors.blueGreyColor,
              ),
            ),
          ],
        ),
      );
    });
  }

  showCommentSheet(BuildContext context,DocumentSnapshot documentSnapshot,String postId,String type){
    return showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: constantColors.whiteColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text('Comments',style: TextStyle(color: constantColors.blueColor,fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*.52,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection(type).doc(postId).collection('comments').orderBy('time').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else{
                            return ListView(
                              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                                return Wrap(
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: CircleAvatar(
                                                  backgroundColor: constantColors.darkColor,
                                                  radius: 15,
                                                  backgroundImage: NetworkImage(documentSnapshot['userimage']),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 5.0),
                                                child: Container(
                                                  child: Text(documentSnapshot['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                                ),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onLongPress: (){
                                                        Navigator.pop(context);
                                                        showLikesOnComment(context, postId, documentSnapshot, type);
                                                      },
                                                      child: IconButton(onPressed: (){
                                                        addLikeOnComment(context, documentSnapshot, postId, type);
                                                      }, icon: Icon(FontAwesomeIcons.arrowUp,color: constantColors.blueColor,size: 12,)),
                                                    ),
                                                    StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(documentSnapshot.id).collection('likeoncomment').snapshots(),
                                                        builder: (context,snapshot){
                                                          if(snapshot.connectionState==ConnectionState.waiting){
                                                            return Center(child: CircularProgressIndicator(),);
                                                          }
                                                          else{
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                                            );
                                                          }
                                                        }),
                                                    IconButton(onPressed: (){
                                                      Navigator.pop(context);
                                                      showCommentInComment(context, documentSnapshot, postId,documentSnapshot['username'],documentSnapshot['userimage'], type);
                                                    }, icon: Icon(FontAwesomeIcons.reply,color: constantColors.yellowColor,size: 12,)),
                                                    StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(documentSnapshot.id).collection('commentoncomment').snapshots(),
                                                        builder: (context,snapshot){
                                                          if(snapshot.connectionState==ConnectionState.waiting){
                                                            return const Center(child: CircularProgressIndicator(),);
                                                          }
                                                          else{
                                                            return Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                                                            );
                                                          }
                                                        }),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Row(
                                              children: [
                                                IconButton(onPressed: (){},
                                                    icon: Icon(Icons.arrow_forward_ios_outlined,color: constantColors.blueColor,size: 12,)),
                                                Container(
                                                  width: MediaQuery.of(context).size.width*.7,
                                                  child: Linkable(text:documentSnapshot['comment'],style: TextStyle(color: constantColors.whiteColor,fontSize: 15),textColor: constantColors.whiteColor,),
                                                ),
                                                documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid?IconButton(onPressed: (){
                                                  FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(documentSnapshot.id).delete();
                                                }, icon: Icon(FontAwesomeIcons.trashAlt,color: constantColors.redColor,size: 16,)):Container(height: 0,width: 0,)

                                              ],
                                            ),
                                          ),
                                          Divider(color: constantColors.darkColor.withOpacity(.2),),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            );
                          }
                        }),
                  ),
                  Wrap(
                    children: [
                      Container(

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*.7,
                              height: 20,
                              child: TextField(
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: 'Add Comment',
                                  hintStyle: TextStyle(
                                      color: constantColors.greyColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                controller: commentController,
                                style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),
                              ),
                            ),
                            FloatingActionButton(
                              onPressed: (){
                                addComment(documentSnapshot['caption'], commentController.text, context, type).whenComplete((){
                                  commentController.clear();
                                  notifyListeners();
                                });

                              },
                              child: Icon(FontAwesomeIcons.comment,color: constantColors.whiteColor,),
                              backgroundColor: constantColors.blueColor,)
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color:constantColors.blueGreyColor,
              ),
            )
          ],
        ),
      );
    });
  }

  showTimeAgo(dynamic timedata){
    Timestamp time=timedata;
    DateTime dateTime=time.toDate();
    imageTimePosted=timeago.format(dateTime);
    print(imageTimePosted);
  }

  showPostOptions(BuildContext context,String postId,String type){
    return showModalBottomSheet(isScrollControlled: true ,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height*.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(color: constantColors.blueColor,onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Wrap(
                            children: [
                              Container(
                                color: constantColors.blueGreyColor,
                                child: Center(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*.7,
                                        height: 50,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Add New Caption',
                                            hintStyle: TextStyle(color: constantColors.greyColor,fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),
                                          controller:editCommentController ,
                                        ),
                                      ),
                                      FloatingActionButton(child: Icon(FontAwesomeIcons.fileUpload,color: constantColors.whiteColor,),backgroundColor: constantColors.redColor,onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).updatePost(postId,{
                                        'caption':editCommentController.text
                                      },type).whenComplete(() => Navigator.pop(context));}),
                                    ],),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },child: Text('Edit Caption',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                    MaterialButton(color: constantColors.redColor,onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          backgroundColor: constantColors.blueGreyColor,
                          title: Text('Delete this Post ?',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),),
                          actions: [
                            MaterialButton(onPressed: (){Navigator.pop(context);},child: Text('No',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                            MaterialButton(color: constantColors.redColor,onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).deleteUserData(postId,type).whenComplete(() => Navigator.pop(context));},child: Text('Yes',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),

                          ],
                        );
                      });

                    },child: Text('Delete Post',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  showSupportOptions(BuildContext context,String postId,String type){
    return showModalBottomSheet(isScrollControlled: true ,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height*.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(color: constantColors.blueColor,onPressed: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Wrap(
                            children: [
                              Container(
                                color: constantColors.blueGreyColor,
                                child: Center(
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*.7,
                                        height: 50,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Add New Caption',
                                            hintStyle: TextStyle(color: constantColors.greyColor,fontSize: 16,fontWeight: FontWeight.bold),
                                          ),
                                          style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),
                                          controller:editCommentController ,
                                        ),
                                      ),
                                      FloatingActionButton(child: Icon(FontAwesomeIcons.fileUpload,color: constantColors.whiteColor,),backgroundColor: constantColors.redColor,onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).updatePost(postId,{
                                        'caption':editCommentController.text
                                      },type).whenComplete(() => Navigator.pop(context));}),
                                    ],),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },child: Text('Edit Caption',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                    MaterialButton(color: constantColors.redColor,onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          backgroundColor: constantColors.blueGreyColor,
                          title: Text('Delete this Post ?',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),),
                          actions: [
                            MaterialButton(onPressed: (){Navigator.pop(context);},child: Text('No',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                            MaterialButton(color: constantColors.redColor,onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).deleteUserData(postId,type).whenComplete(() => Navigator.pop(context));},child: Text('Yes',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),

                          ],
                        );
                      });

                    },child: Text('Delete Post',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                    MaterialButton(color: Colors.green,onPressed: (){
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          backgroundColor: constantColors.blueGreyColor,
                          title: Text('Problem Solved ?',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),),
                          actions: [
                            MaterialButton(onPressed: (){Navigator.pop(context);},child: Text('No',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                            MaterialButton(color: constantColors.redColor,onPressed: (){FirebaseFirestore.instance.collection("support").doc(postId).update({"work":"Solved"});},child: Text('Yes',style: TextStyle(decoration: TextDecoration.underline,decorationColor: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),

                          ],
                        );
                      });

                    },child: Text('Solved',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: constantColors.whiteColor),),),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

}