import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Social%20Media/profile_screen.dart';
import 'package:provider/provider.dart';
import '../../Services/firebase_operations.dart';
import '../SupportScreen/details_screen.dart';
import 'alt_profile.dart';

class AltProfileHelper with ChangeNotifier{
  ConstantColors constantColors=ConstantColors();
  get element => _element;
  // ignore: prefer_typing_uninitialized_variables
  var _element;

  // ignore: non_constant_identifier_names
  Widget Information(BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot,String userId){
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
                      onTap: ()async { final db = FirebaseFirestore.instance;
                      var result=await db.collection('users').get();
                      result.docs.forEach((res) {
                        _element=res.id;
                      }
                      );
                      checkFollowersSheet(context, snapshot,element);
                      },
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
                      onTap: (){checkFollowingSheet(context, snapshot,userId);},
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
              const SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height*.05,
                width: MediaQuery.of(context).size.width*.29,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: constantColors.secondary
                ),
                child: InkWell(
                  onTap: (){
                    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc) {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .followUsers(
                          userId,
                          FirebaseAuth.instance.currentUser!.uid,
                          {
                            'username': doc['username'],
                            'userimage': doc['userimage'],
                            'useremail': doc['useremail'],
                            'useruid': doc['useruid'],
                            'time': Timestamp.now()
                          },
                          FirebaseAuth.instance.currentUser!.uid,
                          userId,
                          {
                            'username': snapshot.data!['username'],
                            'useremail': snapshot.data!['useremail'],
                            'useruid': snapshot.data!['useruid'],
                            'userimage': snapshot.data!['userimage'],
                            'time': Timestamp.now()
                          });
                    });
                  },child:Center(child: Text('Follow',style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),))),
              ),

            ],
          ),
        ),
      ],
    );
  }

  checkFollowersSheet(BuildContext context,dynamic snapshot,String userid){
    return showModalBottomSheet(context: context, builder:(context){
      return Container(
        height: MediaQuery.of(context).size.height*.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor),
        child:StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(snapshot.data!['useruid']).collection('followers').snapshots()
            ,builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){return const Center(child: CircularProgressIndicator(),);}
              else{
                return  ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot)  {
                    return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ListTile(
                            onTap: (){
                              if(documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid){Navigator.pushReplacement(context, PageTransition(child:const ProfileScreen(), type: PageTransitionType.leftToRight));}
                              else {
                                Navigator.pushReplacement(context, PageTransition(child: AltProfile(documentSnapshot['useruid']), type: PageTransitionType.leftToRight));
                              }},
                            leading: CircleAvatar(backgroundColor: constantColors.darkColor,backgroundImage: NetworkImage(documentSnapshot['userimage']),),
                            title: Text(documentSnapshot['username'],style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 18),),
                            subtitle: Text(documentSnapshot['useremail'],style: TextStyle(color: constantColors.yellowColor,fontWeight: FontWeight.bold,fontSize: 14),),
                            trailing: documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid?const SizedBox(height: 0,width: 0,):MaterialButton(onPressed: (){Navigator.pushReplacement(context, PageTransition(child: AltProfile(documentSnapshot['useruid']), type: PageTransitionType.leftToRight));},child: Text('View',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),color: constantColors.blueColor,)
                        )
                    );
                  }).toList(),
                );
              }
            }),
      );
    } );
  }

  checkFollowingSheet(BuildContext context,dynamic snapshot,String useruid){
    return showModalBottomSheet(context: context, builder:(context){
      return Container(
        height: MediaQuery.of(context).size.height*.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: constantColors.blueGreyColor),
        child:StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').doc(useruid).collection('following').snapshots()
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
                          trailing:  documentSnapshot['useruid']==FirebaseAuth.instance.currentUser!.uid?const SizedBox(height: 0,width: 0,):MaterialButton(onPressed: (){Navigator.pushReplacement(context, PageTransition(child: AltProfile(documentSnapshot['useruid']), type: PageTransitionType.leftToRight));},child: Text('View',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),color: constantColors.blueColor,),
                        )
                    );
                  }).toList(),
                );
              }
            }),
      );
    } );
  }

  Widget footerProfile(BuildContext context,dynamic snapshot,String userId){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.
          collection('posts').where('useruid',isEqualTo: userId).snapshots(),
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