import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persona/Pages/BuyProduct/product_helper.dart';
import 'package:persona/Pages/EditProfile/edit_profile_helper.dart';
import 'package:persona/Pages/HomeScreen/home_helper.dart';
import 'package:persona/Pages/LoginSystem/login_system_helper.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:persona/Pages/Social%20Media/alt_profile_helper.dart';
import 'package:persona/Pages/Social%20Media/social_helper.dart';
import 'package:persona/Pages/SupportScreen/support_helper.dart';
import 'package:persona/Utils/post_options.dart';
import 'package:persona/Utils/upload_post.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'Pages/SplashScreen/splash_screen.dart';
import 'Services/authentication.dart';
import 'Services/firebase_operations.dart';
import 'Services/notifications.dart';

Future <void> main()async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,);
    runApp(const MyApp());
  }
  catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    LocalNotifications.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message!=null){
        final routeFromMessage=message.data['route'];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      if(message.notification!=null){
      }
      LocalNotifications.display(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage=message.data['route'];
      Navigator.of(context).pushNamed(routeFromMessage);
    });

  }

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>Authentication()),
        ChangeNotifierProvider(create: (_)=>FirebaseOperations()),
        ChangeNotifierProvider(create: (_)=>LoginSystemHelper()),
        ChangeNotifierProvider(create: (_)=>EditProfileHelper()),
        ChangeNotifierProvider(create: (_)=>ProductHelper()),
        ChangeNotifierProvider(create: (_)=>PersonaHelper()),
        ChangeNotifierProvider(create: (_)=>SocialHelper()),
        ChangeNotifierProvider(create: (_)=>SupportHelper()),
        ChangeNotifierProvider(create: (_)=>AltProfileHelper()),
        ChangeNotifierProvider(create: (_)=>PostOptions()),
        ChangeNotifierProvider(create: (_)=>UploadPost()),
        ChangeNotifierProvider(create: (_)=>HomeHelper()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: ResponsiveSizer(builder:(context,orientation,screenType)=> const SplashScreen()),
      ),
    );
  }
}

Future backgroundHandler(RemoteMessage message)async{
  // ignore: avoid_print
  print(message.data.toString());
  // ignore: avoid_print
  print(message.notification!.title);
}