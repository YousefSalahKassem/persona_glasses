import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/HomeScreen/home_screen.dart';
import 'package:persona/Widgets/drawer_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _drawerController = ZoomDrawerController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ConstantColors constantColors=ConstantColors();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: scaffoldKey,
      body: ZoomDrawer(
        controller: _drawerController,
        menuScreen: const DrawerScreen(),
        mainScreen:  HomeScreen(_drawerController),
        borderRadius: 24.0,
        angle: 0,
        showShadow: true,
        style: DrawerStyle.Style1,
        backgroundColor: Colors.blueGrey,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
      ),
    );
  }
}
