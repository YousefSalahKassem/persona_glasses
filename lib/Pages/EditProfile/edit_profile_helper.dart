import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Pages/LoginSystem/forgot_password.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';

import '../../Constants/constants_color.dart';

class EditProfileHelper with ChangeNotifier{
  String image = FirebaseAuth.instance.currentUser!.photoURL!;
  late File uploadPostImage;
  File get getUploadPostImage=>uploadPostImage;
  String uploadPostImageUrl=FirebaseAuth.instance.currentUser!.photoURL!;
  String get getUploadPostImageUrl => uploadPostImageUrl;
  final picker=ImagePicker();
  late UploadTask imagePostUploadTask;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController firstNameController=TextEditingController();
  TextEditingController lastNameController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  ConstantColors constantColors=ConstantColors();

  Future pickUploadPostImage(BuildContext context,ImageSource source)async{
    final uploadPostImageVal=await picker.getImage(source: source);
    uploadPostImageVal==null?
    print('Select image')
        : uploadPostImage=File(uploadPostImageVal.path);

    notifyListeners();
  }

  Future uploadPostImageToFirebase()async{
    // ignore: non_constant_identifier_names
    Reference ImageReference=FirebaseStorage.instance.ref().child('posts/${uploadPostImage.path}/${TimeOfDay.now()}');
    imagePostUploadTask=ImageReference.putFile(uploadPostImage);
    await imagePostUploadTask.whenComplete(() {

    });
    ImageReference.getDownloadURL().then((value)async {
      uploadPostImageUrl=await value;
      image=value;
    });

    notifyListeners();
  }

  Widget changeImage(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: CachedNetworkImageProvider(image),
        ),
        Positioned(
            right: 10,
            bottom: 1,
            child: Container(
                decoration:  BoxDecoration(
                    color: constantColors.secondary,
                    borderRadius: const BorderRadius.all(Radius.circular(50))),
                child: Center(
                    child: IconButton(
                        onPressed: () {
                          pickUploadPostImage(context, ImageSource.gallery).whenComplete(() => uploadPostImageToFirebase());
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                        ))))),
      ],
    );
  }

  Widget firstName(BuildContext context){
    return  Container(
      width:Adaptive.w(MediaQuery.of(context).size.width*5),
      height: Adaptive.h(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: constantColors.primary)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width*.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0,right: 1.0),
              child: TextFormField(
                controller: firstNameController,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                decoration:  InputDecoration(
                  hintText: FirebaseAuth.instance.currentUser!.displayName!,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  fillColor: Colors.black,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                  focusedBorder:
                  const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget lastName(BuildContext context){
    return  Container(
      width:Adaptive.w(MediaQuery.of(context).size.width*5),
      height: Adaptive.h(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: constantColors.primary)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width*.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0,right: 1.0),
              child: TextFormField(
                controller: lastNameController,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                decoration:  InputDecoration(
                  hintText: FirebaseAuth.instance.currentUser!.displayName!,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  fillColor: Colors.black,
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                  focusedBorder:
                  const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget email(BuildContext context){
    return  Container(
      width:Adaptive.w(MediaQuery.of(context).size.width*5),
      height: Adaptive.h(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: constantColors.primary)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width*.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0,right: 1.0),
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                decoration:  InputDecoration(
                  hintText: FirebaseAuth.instance.currentUser!.email!,
                  hintStyle:const TextStyle(
                    color: Colors.grey,
                  ),
                  fillColor: Colors.black,
                  enabledBorder:const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget phone(BuildContext context){
    return  Container(
      width:Adaptive.w(MediaQuery.of(context).size.width*5),
      height: Adaptive.h(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: constantColors.primary)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width*.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0,right: 1.0),
              child: TextFormField(
                keyboardType:TextInputType.number,
                controller: phoneController,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '+2-123-456-7890',
                  hintStyle:  TextStyle(
                    color: Colors.grey,
                  ),
                  fillColor: Colors.black,
                  enabledBorder:  UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                  focusedBorder:
                  UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget address(BuildContext context){
    return  Container(
      width:Adaptive.w(MediaQuery.of(context).size.width*5),
      height: Adaptive.h(7),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: constantColors.primary)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width*.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0,right: 1.0),
              child: TextFormField(
                controller: addressController,
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Address',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  fillColor: Colors.black,
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                  focusedBorder:
                  UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.transparent)
                  ),
                ),),
            ),
          ),
        ],
      ),
    );
  }

  Widget resetPassword(BuildContext context){
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, PageTransition(child: const ForgotPassword(), type: PageTransitionType.rightToLeft));
      },
      child: Container(
        height: MediaQuery.of(context).size.height*.07,
        width: MediaQuery.of(context).size.width*.5,
        decoration: BoxDecoration(
          color: constantColors.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(child: Text("Reset Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(18)),)),
      ),
    );
  }

}