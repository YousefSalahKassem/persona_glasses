import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Pages/Social%20Media/profile_screen.dart';
import 'package:persona/Pages/SupportScreen/details_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Constants/constants_color.dart';
import '../../Services/firebase_operations.dart';
import '../../Utils/post_options.dart';
import 'alt_profile.dart';
import 'image_screen.dart';

class SocialHelper with ChangeNotifier {

  ConstantColors constantColors = ConstantColors();

  TextEditingController commentController=TextEditingController();

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Explorer",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
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
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('time', descending: true)
                      .snapshots(),
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
                                InkWell(
                                  onTap:(){
                                    if(documentSnapshot["useruid"]==FirebaseAuth.instance.currentUser!.uid) {}
                                    else{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AltProfile(documentSnapshot["useruid"])));
                                    }
                                  },
                                  child: Row(
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
                          documentSnapshot['postimage'] != "" ? Padding(
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
                                ) : const SizedBox(
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
                                        .collection('posts')
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
                                                documentSnapshot['caption'],"posts");
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
                                          Provider.of<PostOptions>(context,listen: false).addComment(documentSnapshot["caption"], value.toString(), context,"posts").whenComplete(() {
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
      }).toList(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Information(BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50,
          backgroundImage: CachedNetworkImageProvider(snapshot.data!['userimage'] ?? FirebaseAuth.instance.currentUser!.photoURL),
        ),
        const SizedBox(height: 10,),
        Text(snapshot.data!['username'] ?? FirebaseAuth.instance.currentUser!.displayName,style:const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
        Text(snapshot.data!['useremail'] ?? FirebaseAuth.instance.currentUser!.email,style:const TextStyle(color: Colors.grey,fontSize: 16,),),
        SizedBox(
          width: 200,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top:16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){checkFollowersSheet(context, snapshot);},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!['useruid']).collection('followers').snapshots()
                              ,builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){return const Center(child: CircularProgressIndicator(),);}
                                else{return Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 28),);
                                }
                              }),
                          Text('Followers',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 12),),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    InkWell(
                      onTap: (){checkFollowingSheet(context, snapshot);},
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!['useruid']).collection('following').snapshots()
                              ,builder: (context,snapshot){
                                if(snapshot.connectionState==ConnectionState.waiting){return const Center(child: CircularProgressIndicator(),);}
                                else{return Text(snapshot.data!.docs.length.toString(),style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 28),);
                                }
                              }),
                          Text('Following',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 12),),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  checkFollowingSheet(BuildContext context,dynamic snapshot){
    return showModalBottomSheet(context: context, builder:(context){
      return Container(
        height: MediaQuery.of(context).size.height*.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor,),
        child:StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!['useruid']).collection('following').snapshots()
            ,builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){return const Center(child: CircularProgressIndicator(),);}
              else{
                return  ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot){
                    return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ListTile(
                          onTap: (){
                            if(documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid){Navigator.pushReplacement(context, PageTransition(child: const ProfileScreen(), type: PageTransitionType.leftToRight));}
                            else {
                              Navigator.pushReplacement(context, PageTransition(child: AltProfile(documentSnapshot['useruid']), type: PageTransitionType.leftToRight));
                            }},
                          leading: CircleAvatar(backgroundColor: constantColors.darkColor,backgroundImage: NetworkImage(documentSnapshot['userimage']),),
                          title: Text(documentSnapshot['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                          subtitle: Text(documentSnapshot['useremail'],style: TextStyle(color: constantColors.yellowColor,fontWeight: FontWeight.bold,fontSize: 14),),
                          trailing: MaterialButton(onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).unFollowUsers(context, documentSnapshot['useruid']);},child: Text('Unfollow',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),color: constantColors.blueColor,),
                        )
                    );
                  }).toList(),
                );
              }
            }),
      );
    } );
  }

  checkFollowersSheet(BuildContext context,dynamic snapshot){
    return showModalBottomSheet(context: context, builder:(context){
      return Container(
        height: MediaQuery.of(context).size.height*.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor),
        child:StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('followers').snapshots()
            ,builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){return const Center(child: CircularProgressIndicator(),);}
              else{
                return  ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot)  {
                    return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ListTile(
                            onTap: (){
                              if(documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid){Navigator.pushReplacement(context, PageTransition(child: const ProfileScreen(), type: PageTransitionType.leftToRight));}
                              else {
                                Navigator.pushReplacement(context, PageTransition(child: AltProfile(documentSnapshot['useruid']), type: PageTransitionType.leftToRight));
                              }},
                            leading: CircleAvatar(backgroundColor: constantColors.darkColor,backgroundImage: NetworkImage(documentSnapshot['userimage']),),
                            title: Text(documentSnapshot['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                            subtitle: Text(documentSnapshot['useremail'],style: TextStyle(color: constantColors.yellowColor,fontWeight: FontWeight.bold,fontSize: 14),),
                            trailing: documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid?const SizedBox(height: 0,width: 0,):MaterialButton(onPressed: (){Provider.of<FirebaseOperations>(context,listen: false).unFollowAltUsers(context, documentSnapshot['useruid']);},child: Text('Remove',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),color: constantColors.blueColor,)
                        )
                    );
                  }).toList(),
                );
              }
            }),
      );
    } );
  }

  Widget footerProfile(BuildContext context,dynamic snapshot){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.
          collection('posts').where('useruid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots()
          ,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return  GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children: snapshot.data!.docs.map((DocumentSnapshot snapshot){
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(snapshot)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          child: CachedNetworkImage(imageUrl: snapshot['postimage'],fit: BoxFit.cover,),
                        ),
                      ),
                    );
                  }).toList());
            }
          },
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5)
        ),
      ),
    );
  }

}
