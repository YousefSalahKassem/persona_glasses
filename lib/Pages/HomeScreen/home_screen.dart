import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/BuyProduct/product_screen.dart';
import 'package:persona/Pages/WifiScreen/main_screen.dart';
import 'package:persona/Pages/Social%20Media/album_screen.dart';
import 'package:persona/Pages/Social%20Media/profile_screen.dart';
import 'package:persona/Pages/Social%20Media/social_screen.dart';


class HomeScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final zoomDrawerController;

  const HomeScreen(this.zoomDrawerController, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey2 =  GlobalKey<ScaffoldState>();
  ConstantColors constantColors=ConstantColors();
  int index=0;

  final screens=[
    const SocialScreen(),
    const ProductScreen(),
    null,
    const AlbumScreen(),
    const ProfileScreen()
  ];

  final items=<Widget> [
   const Icon(Icons.home,size: 30,color: Colors.white,),
   const Icon(Icons.shopping_cart,size: 30,color: Colors.white,),
   const Icon(FontAwesomeIcons.camera,size: 25,color: Colors.white,),
   const Icon(FontAwesomeIcons.heart,size: 30,color: Colors.white,),
    FirebaseAuth.instance.currentUser!.photoURL!.isEmpty?Container():CircleAvatar(backgroundImage: CachedNetworkImageProvider(FirebaseAuth.instance.currentUser!.photoURL!),backgroundColor: Colors.transparent,radius: 20,),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: index==4?constantColors.blueGreyColor:Colors.transparent,
          centerTitle: true,
          title: const Text("Persona",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
          leading: IconButton(onPressed: ()=>widget.zoomDrawerController.toggle(), icon: const Icon(Icons.menu)),
          actions: [IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> MainPage()));}, icon:const Icon(Icons.settings,color: Colors.white,))],
        ),
        backgroundColor: constantColors.background,
        body: screens[index],
        bottomNavigationBar: CurvedNavigationBar(
            key: scaffoldKey2,
            color: constantColors.card,
            animationCurve: Curves.easeInOut,
            animationDuration:const Duration(milliseconds: 300),
            buttonBackgroundColor: constantColors.secondary,
            backgroundColor: Colors.transparent,
            items: items,
            height: 60,
            index: index,
            onTap: (index)=>setState(() {
              this.index=index;
            }),
        ),
      ),
    );
  }
}


