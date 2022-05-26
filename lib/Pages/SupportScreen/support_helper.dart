import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:linkable/linkable.dart';
import 'package:persona/Pages/SupportScreen/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Constants/constants_color.dart';
import '../../Utils/post_options.dart';
import '../Social Media/image_screen.dart';

class SupportHelper with ChangeNotifier{
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController=TextEditingController();

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18)),
              ),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('support').orderBy('time', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          height: 500,
                          width: 400,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return loadPosts(context, snapshot);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadPosts(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Provider.of<PostOptions>(context, listen: false).showTimeAgo(documentSnapshot['time']);
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailsScreen(documentSnapshot)));
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
            child: Wrap(children: [
              Container(
                      decoration: BoxDecoration(
                      color: constantColors.blueGreyColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                      child: Padding(padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Persona Usages",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('support').doc(documentSnapshot['caption']).collection('comments').snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return CircleAvatar(backgroundColor: Colors.red,radius: 15,child: Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),);
                                        }
                                      }),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 20.0),
                              child: Linkable(text:documentSnapshot['caption'],style: TextStyle(color: constantColors.whiteColor,fontSize: 16),textColor: constantColors.whiteColor,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: constantColors.blueGreyColor,
                                        radius: 20,
                                        backgroundImage:
                                        NetworkImage(documentSnapshot['userimage']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              documentSnapshot['username'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: constantColors.whiteColor,
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              Provider.of<PostOptions>(context,
                                                  listen: false)
                                                  .getImageTimePosted
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: constantColors.greyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  FirebaseAuth.instance.currentUser!.uid ==
                                      documentSnapshot['useruid']
                                      ? IconButton(
                                      onPressed: () {
                                        Provider.of<PostOptions>(context,
                                            listen: false)
                                            .showSupportOptions(
                                            context, documentSnapshot.id,"support");
                                      },
                                      icon: Icon(
                                        EvaIcons.moreVertical,
                                        color: constantColors.whiteColor,
                                      ))
                                      : const SizedBox(width: 0, height: 0)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0,top: 15.0),
                              child: Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: documentSnapshot["work"]=="In Work"?constantColors.yellowColor.withOpacity(.8):Colors.green,
                                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Center(
                                  child: Text(documentSnapshot["work"],style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                                ),
                              ),
                            )
                          ])))
            ]),
          ),
        );
      }).toList(),
    );
  }

  Widget technicalPost(BuildContext context,DocumentSnapshot documentSnapshot){
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
      child:
      Wrap(children: [
        Container(
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: const BorderRadius.all(Radius.circular(15))),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: constantColors.blueGreyColor,
                                  radius: 20,
                                  backgroundImage:
                                  NetworkImage(documentSnapshot['userimage']),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        documentSnapshot['username'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: constantColors.whiteColor,
                                        ),
                                      ),
                                      Text(
                                        Provider.of<PostOptions>(context,
                                            listen: false)
                                            .getImageTimePosted
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: constantColors.greyColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            FirebaseAuth.instance.currentUser!.uid ==
                                documentSnapshot['useruid']
                                ? IconButton(
                                onPressed: () {
                                  Provider.of<PostOptions>(context,
                                      listen: false)
                                      .showPostOptions(
                                      context, documentSnapshot.id,"posts");
                                },
                                icon: Icon(
                                  EvaIcons.moreVertical,
                                  color: constantColors.whiteColor,
                                ))
                                : const SizedBox(width: 0, height: 0)
                          ],
                        ),
                      ),
                      documentSnapshot['postimage'] != ""
                          ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height:
                          MediaQuery.of(context).size.height * .45,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ImageDetails(
                                                documentSnapshot[
                                                'postimage'])));
                              },
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl:
                                          documentSnapshot['postimage'],
                                          height: double.infinity,
                                          width: double.infinity,
                                          fit: BoxFit.cover),
                                      Positioned(
                                          left: 10,
                                          bottom: 10,
                                          child: InkWell(
                                            onLongPress: (){Provider.of<PostOptions>(context,listen: false).showLikes(context,documentSnapshot['caption'],"posts");},
                                            onTap: (){Provider.of<PostOptions>(context,listen: false).addLike(context, documentSnapshot['caption'], FirebaseAuth.instance.currentUser!.uid,"posts");},
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: constantColors.secondary,
                                                borderRadius:const BorderRadius.all(Radius.circular(50)),
                                              ),
                                              child: const Icon(FontAwesomeIcons.solidHeart,color: Colors.white,size: 18,),
                                            ),
                                          ))
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      )
                          : const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      documentSnapshot['postimage'] != ""?Padding(padding: const EdgeInsets.only(left: 15.0), child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot['caption'])
                              .collection('likes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child:
                                CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0),
                                child: Text(
                                  snapshot.data!.docs.length
                                      .toString()+ " likes",
                                  style: TextStyle(
                                      color: constantColors
                                          .whiteColor,
                                      fontSize: 16),
                                ),
                              );
                            }
                          }),):Container(),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(documentSnapshot["username"],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold),),
                                const SizedBox(width: 5,),
                                Text(documentSnapshot["caption"],style: TextStyle(color: constantColors.whiteColor.withOpacity(.8)),)
                              ],
                            ),
                            const SizedBox(height: 10,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('support')
                                    .doc(documentSnapshot['caption'])
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child:
                                      CircularProgressIndicator(),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Provider.of<PostOptions>(context,
                                            listen: false)
                                            .showCommentSheet(
                                            context,
                                            documentSnapshot,
                                            documentSnapshot['caption'],"support");
                                      },
                                      child: Text("view all "+
                                          snapshot.data!.docs.length
                                              .toString()+" comments",
                                        style: TextStyle(
                                            color: constantColors
                                                .greyColor,
                                            fontSize: 14),
                                      ),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0,top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor: constantColors.blueGreyColor,
                              radius: 20,
                              backgroundImage:
                              NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: SizedBox(
                                height: 50,
                                width: Adaptive.w(65),
                                child:
                                TextField(
                                  onSubmitted: (value){
                                    Provider.of<PostOptions>(context,listen: false).addComment(documentSnapshot["caption"], value.toString(), context,"support").whenComplete(() {
                                      commentController.clear();
                                      notifyListeners();
                                    });
                                  },
                                  textInputAction: TextInputAction.send,
                                  controller: commentController,
                                  maxLines: null,
                                  decoration:const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add a comment...",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12
                                      )
                                  ),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                  ),
                                ),

                              ),
                            ),
                          ],
                        ),
                      )
                    ])))
      ]),
    );
  }

}