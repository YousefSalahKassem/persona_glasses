import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/EditProfile/edit_profile_helper.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
import 'package:provider/provider.dart';

import '../../Services/firebase_operations.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,right: 15,left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center,child: Provider.of<EditProfileHelper>(context,listen: false).changeImage(context)),
              const SizedBox(height: 20,),
              const Text("Personal Information",style: TextStyle(color: Colors.grey,fontSize: 14),),
              const SizedBox(height: 25,),
              const Text("First Name",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 10,),
              Provider.of<EditProfileHelper>(context,listen: false).firstName(context),
              const SizedBox(height: 15,),
              const Text("Last Name",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).lastName(context),
              const SizedBox(height: 10,),
              const Text("Email",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).email(context),
              const SizedBox(height: 10,),
              const Text("Phone Number",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).phone(context),
              const SizedBox(height: 10,),
              const Text("Address",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).address(context),
              const SizedBox(height: 35,),
              Provider.of<EditProfileHelper>(context,listen: false).resetPassword(context),
              const SizedBox(height: 50,),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Provider.of<EditProfileHelper>(context,listen: false).uploadPostImageToFirebase();
        var user = FirebaseAuth.instance.currentUser!;
        user.updateProfile(
        displayName: Provider.of<EditProfileHelper>(context,listen: false).firstNameController.text.isEmpty||Provider.of<EditProfileHelper>(context,listen: false).lastNameController.text.isEmpty
        ?FirebaseAuth.instance.currentUser!.displayName: Provider.of<EditProfileHelper>(context,listen: false).firstNameController.text+" "+Provider.of<EditProfileHelper>(context,listen: false).lastNameController.text,
        photoURL:  Provider.of<EditProfileHelper>(context,listen: false).getUploadPostImageUrl.isEmpty?FirebaseAuth.instance.currentUser!.photoURL: Provider.of<EditProfileHelper>(context,listen: false).getUploadPostImageUrl)
        .whenComplete(() async {
          Provider.of<FirebaseOperations>(context, listen: false)
              .createUserCollection(context, {
            'useruid': FirebaseAuth.instance.currentUser!.uid,
            'useremail': FirebaseAuth.instance.currentUser!.email,
            'username': FirebaseAuth.instance.currentUser!.displayName,
            'userimage': FirebaseAuth.instance.currentUser!.photoURL,
            "userphone": Provider.of<EditProfileHelper>(context,listen: false).phoneController.text,
            "useraddress": Provider.of<EditProfileHelper>(context,listen: false).addressController.text,
          });
          Navigator.pushReplacement(context, PageTransition(child: const MenuScreen(), type: PageTransitionType.rightToLeft));});
      },backgroundColor: constantColors.secondary,child: Icon(Icons.save,color: constantColors.whiteColor,size: 35,),),
    );
  }
}
