import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../Constants/constants_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/firebase_operations.dart';

class UploadPost with ChangeNotifier{

  ConstantColors constantColors=ConstantColors();
  late File uploadPostImage;
  File get getUploadPostImage=>uploadPostImage;
  late String uploadPostImageUrl;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker=ImagePicker();
  late UploadTask imagePostUploadTask;
  TextEditingController captionController=TextEditingController();

  Future pickUploadPostImage(BuildContext context,ImageSource source,String type)async{
    final uploadPostImageVal=await picker.getImage(source: source);
    uploadPostImageVal==null?
    print('Select image')
        : uploadPostImage=File(uploadPostImageVal.path);


    uploadPostImage != null ? showPostImage(context,type):print('Image upload error');
    notifyListeners();
  }

  selectPostImage(BuildContext context,String type) {
    return showModalBottomSheet(context: context, builder: (context){
      return Wrap(
        children: [
          Container(
            color: constantColors.blueGreyColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(color: constantColors.blueColor,onPressed: (){pickUploadPostImage(context, ImageSource.gallery, type);},child: Text('Gallery',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),),
                    MaterialButton(color: constantColors.blueColor,onPressed: (){pickUploadPostImage(context, ImageSource.camera, type);},child: Text('Camera',style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),),
                    MaterialButton(color: constantColors.blueColor,onPressed: (){PostSheet(context,type);},child: Text("Post",style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Future uploadPostImageToFirebase()async{
    // ignore: non_constant_identifier_names
    Reference ImageReference=FirebaseStorage.instance.ref().child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask=ImageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {

    });
    ImageReference.getDownloadURL().then((value)async {
      uploadPostImageUrl=await value;
    });

    notifyListeners();
  }

  showPostImage(BuildContext context,String type) {
    return showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Wrap(
        children: [
          Container(
            color: constantColors.darkColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,left: 8,right: 8),
                  child: SizedBox(
                    height: Adaptive.h(20),
                    width: Adaptive.w(40),
                    child: Image.file(uploadPostImage,fit: BoxFit.contain,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(onPressed: (){
                        Navigator.pop(context);
                        selectPostImage(context,type);
                      },
                          child:Text('Reselect',style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: constantColors.whiteColor,
                          ),)),
                      MaterialButton(onPressed: (){
                        uploadPostImageToFirebase();
                        Navigator.pop(context);
                        editPostSheet(context,type);

                      },color: constantColors.blueColor,
                          child:Text('Confirm Image',style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  editPostSheet(BuildContext context,String type){
    return showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Container(
              color: constantColors.blueGreyColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  Container(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: Adaptive.h(30),
                          width: Adaptive.w(50),
                          child: Image.file(uploadPostImage,fit: BoxFit.contain,),
                        ),
                      ),
                    ],
                  ),),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 30,width: 30,child: Image.asset('icons/sunflower.png'),),
                        Container(height: 110,width: 5,color: constantColors.blueColor,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(height: 120,width: MediaQuery.of(context).size.width*.7,
                            child: TextField(
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [LengthLimitingTextInputFormatter(100)],
                              maxLength: 100,
                              controller: captionController,
                              style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: InputDecoration(hintText: 'Add A Caption...',hintStyle: TextStyle(color: constantColors.greyColor,fontWeight: FontWeight.bold,fontSize: 13),),
                            ),),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(child: Text('Share',style:TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16))
                    ,onPressed: ()async{
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc){
                        Provider.of<FirebaseOperations>(context,listen: false).uploadPostData(captionController.text,
                            {
                              'postimage':uploadPostImageUrl,
                              'caption':captionController.text,
                              'username':FirebaseAuth.instance.currentUser!.displayName,
                              'userimage':FirebaseAuth.instance.currentUser!.photoURL,
                              'useruid':FirebaseAuth.instance.currentUser!.uid,
                              'time':Timestamp.now(),
                              'useremail':FirebaseAuth.instance.currentUser!.email,
                            },type)
                            // ignore: void_checks
                            .whenComplete((){
                          return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection(type).add(
                              {
                                'postimage':uploadPostImageUrl,
                                'caption':captionController.text,
                                'username':FirebaseAuth.instance.currentUser!.displayName,
                                'userimage':FirebaseAuth.instance.currentUser!.photoURL,
                                'useruid':FirebaseAuth.instance.currentUser!.uid,
                                'time':Timestamp.now(),
                                'useremail':FirebaseAuth.instance.currentUser!.email,
                                'work':"In Work"
                              }
                          ).whenComplete(() => Navigator.pop(context));
                        });
                        notifyListeners();
                      });
                    }
                    ,color: constantColors.blueColor,),
                ],),
            ),
          ],),
      );
    });
  }
  // ignore: non_constant_identifier_names
  PostSheet(BuildContext context,String type){
    return showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
      return Padding(
        padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          children: [
            Container(
              color: constantColors.blueGreyColor,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 30,width: 30,child: Image.asset('icons/sunflower.png'),),
                        Container(height: 110,width: 2,color: constantColors.blueColor,),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(height: 120,width: MediaQuery.of(context).size.width*.7,
                            child: TextField(
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              inputFormatters: [LengthLimitingTextInputFormatter(100)],
                              maxLength: 100,
                              controller: captionController,
                              style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16),
                              decoration: InputDecoration(hintText: 'Add A Caption...',hintStyle: TextStyle(color: constantColors.greyColor,fontWeight: FontWeight.bold,fontSize: 13),),
                            ),),
                        ),
                      ],
                    ),
                  ],
                ),
                MaterialButton(child: Text('Share',style:TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 16))
                  ,onPressed: ()async{
                    if(captionController.text.isEmpty){}
                    else{
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((doc){
                        Provider.of<FirebaseOperations>(context,listen: false).uploadPostData(captionController.text,
                            {
                              'postimage':"",
                              'caption':captionController.text,
                              'username':FirebaseAuth.instance.currentUser!.displayName,
                              'userimage':FirebaseAuth.instance.currentUser!.photoURL,
                              'useruid':FirebaseAuth.instance.currentUser!.uid,
                              'time':Timestamp.now(),
                              'useremail':FirebaseAuth.instance.currentUser!.email,
                            },type)
                        // ignore: void_checks
                            .whenComplete((){
                          return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection(type).add(
                              {
                                'postimage':"",
                                'caption':captionController.text,
                                'username':FirebaseAuth.instance.currentUser!.displayName,
                                'userimage':FirebaseAuth.instance.currentUser!.photoURL,
                                'useruid':FirebaseAuth.instance.currentUser!.uid,
                                'time':Timestamp.now(),
                                'useremail':FirebaseAuth.instance.currentUser!.email,
                                'work':"In Work"
                              }
                          ).whenComplete(() => Navigator.pop(context));
                        });
                        notifyListeners();
                      });
                    }}
                  ,color: constantColors.blueColor,),
              ],),
            ),

          ],
        ),
      );
    });
  }

}