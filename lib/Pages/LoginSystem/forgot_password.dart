import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Pages/LoginSystem/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Constants/constants_color.dart';
import 'login_system_helper.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title:const Text("Forgot Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, PageTransition(child: const LoginScreen(), type: PageTransitionType.rightToLeft));
        }, icon:const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Provider.of<LoginSystemHelper>(context,listen: false).resetInformation(context),
              SizedBox(height: Adaptive.h(1),),
              Provider.of<LoginSystemHelper>(context,listen: false).email(context),
              SizedBox(height: Adaptive.h(3),),
              Provider.of<LoginSystemHelper>(context,listen: false).resetPassword(context),
            ],
          ),
        ),
      ),
    );
  }
}
