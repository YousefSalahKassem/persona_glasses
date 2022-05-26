import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../HomeScreen/menu_screen.dart';
import '../LoginSystem/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("images/logo.png",width: MediaQuery.of(context).size.width*.7,),
          const Text("Persona Smart Glasses",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
        ],
      ), nextScreen: FirebaseAuth.instance.currentUser!=null?const MenuScreen():const LoginScreen(),duration: 3000,splashTransition: SplashTransition.fadeTransition,backgroundColor: const Color(0xFF374851),splashIconSize: 350,pageTransitionType: PageTransitionType.rightToLeft,),
    );
  }
}
