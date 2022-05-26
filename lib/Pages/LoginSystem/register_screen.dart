import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Constants/constants_color.dart';
import 'login_system_helper.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
        backgroundColor: constantColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          toolbarHeight:Adaptive.h(25),
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png",width: MediaQuery.of(context).size.width*.3,),
              const Text("Persona Smart Glasses",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                color: Color(0x5208ffff)
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Adaptive.h(5),),
              Provider.of<LoginSystemHelper>(context,listen: false).name(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).phone(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).email(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).password(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).signUp(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).haveAnAccount(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).or(context),
            ],
          ),
        ),
        bottomNavigationBar:Provider.of<LoginSystemHelper>(context,listen: false).bottomBar(context)
    );
  }
}
