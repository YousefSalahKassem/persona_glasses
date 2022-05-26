import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'authentication.dart';

class FirebaseOperations with ChangeNotifier{
  late String initUserAddress,initUserPhone;
  String get userPhone=>initUserPhone;
  String get userAddress=>initUserAddress;
  String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());

  Future createUserCollection(BuildContext context,dynamic data)async{
    return FirebaseFirestore.instance.collection('users').doc(Provider.of<Authentication>(context,listen: false).getUserUid).set(data);
  }

  Future<dynamic> initUserData(BuildContext context)async {
    return await FirebaseFirestore.instance.collection('users').doc(
        FirebaseAuth.instance.currentUser!.uid).get().then((doc)async {
     initUserPhone = await doc['userphone'];
      initUserAddress =await  doc['useraddress'];
      notifyListeners();
    });

  }

  Future followUsers(String followingUid,String followingDocUid,dynamic followingData,String followerUid,String followerDocUid,dynamic followerData)async{
    return FirebaseFirestore.instance.collection('users').doc(followingUid).collection('followers').doc(followingDocUid).set(followingData).whenComplete(()async {
      return FirebaseFirestore.instance.collection('users').doc(followerUid).collection('following').doc(followerDocUid).set(followerData);
    });
  }

  Future unFollowUsers(BuildContext context,String uid)async{
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('following').doc(uid).delete().whenComplete((){
      return FirebaseFirestore.instance.collection('users').doc(uid).collection('followers').doc(FirebaseAuth.instance.currentUser!.uid).delete();
    });
  }

  Future unFollowAltUsers(BuildContext context,String uid)async{
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('followers').doc(uid).delete().whenComplete((){
      return FirebaseFirestore.instance.collection('users').doc(uid).collection('following').doc(FirebaseAuth.instance.currentUser!.uid).delete();
    });
  }


  Future makeAnOrder(BuildContext context,dynamic data)async{
    return FirebaseFirestore.instance.collection('orders').doc(formattedDate).set(data);
  }

  Future uploadPostData(String posId,dynamic data,String type)async{
    return FirebaseFirestore.instance.collection(type).doc(posId).set(data);
  }

  Future deleteUserData(String uid,dynamic collection)async{
    return FirebaseFirestore.instance.collection(collection).doc(uid).delete();
  }


  Future updatePost(String postId,dynamic data,String type)async{
    return FirebaseFirestore.instance.collection(type).doc(postId).update(data);
  }

  Future submitChatRoomData(String chatRoomName,dynamic data)async{
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomName).set(data);
  }
}