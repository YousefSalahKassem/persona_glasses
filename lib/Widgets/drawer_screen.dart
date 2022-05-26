import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/AboutScreen/about_screen.dart';
import 'package:persona/Pages/BuyProduct/product_screen.dart';
import 'package:persona/Pages/EditProfile/edit_profile_screen.dart';
import 'package:persona/Pages/Persona/persona_menu.dart';
import 'package:persona/Pages/SupportScreen/support_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Pages/LoginSystem/login_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor:constantColors.blueGreyColor,
      body: Container(
        padding:  EdgeInsets.only(top:Adaptive.h(7),left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(top:Adaptive.h(1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundImage: CachedNetworkImageProvider(FirebaseAuth.instance.currentUser!.photoURL!),backgroundColor: Colors.transparent,radius: 50,),
                  const SizedBox(width: 10,),
                  Text(FirebaseAuth.instance.currentUser!.displayName!,style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(20)),),
                  Text(FirebaseAuth.instance.currentUser!.email!,style: const TextStyle(color: Colors.grey,fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(FontAwesomeIcons.userEdit,color: Colors.white,),
                  title: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.robot,color: Colors.white,),
                  title: const Text("Persona",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const PersonaMenu()));
                  },
                ),
                 ListTile(
                  leading: const Icon(Icons.support_agent,color: Colors.white,),
                  title: const Text("Technical Support",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SupportScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded,color: Colors.white,),
                  title: const Text("About Persona",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutScreen()));
                  },
                ),
                ListTile(
                  leading:const Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                  title:const Text("Buy Persona",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductScreen()));
                  },
                ),
              ]
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app,color: Colors.white,),
              title: const Text("Logout",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, PageTransition(child: const LoginScreen(), type: PageTransitionType.rightToLeft));},
            ),
          ],
        ),
      ),
    );
  }
}
