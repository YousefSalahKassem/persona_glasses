import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/HomeScreen/home_screen.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
import 'package:persona/Pages/LoginSystem/forgot_password.dart';
import 'package:persona/Pages/LoginSystem/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Services/authentication.dart';
import '../../Services/firebase_operations.dart';
import 'login_screen.dart';

class LoginSystemHelper with ChangeNotifier{
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  ConstantColors constantColors=ConstantColors();


  Widget email(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
        width: Adaptive.w(MediaQuery.of(context).size.width*5),
        height: Adaptive.h(7),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: constantColors.primary)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: Adaptive.h(6),
              width: MediaQuery.of(context).size.width*.6,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                child: TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Email',
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
            Icon(Icons.email,color: constantColors.secondary,),
          ],
        ),
      ),
    );
  }

  Widget password(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
        width: Adaptive.w(MediaQuery.of(context).size.width*5),
        height: Adaptive.h(7),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: constantColors.primary)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: Adaptive.h(6),
              width: MediaQuery.of(context).size.width*.6,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Password',
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
            Icon(Icons.lock,color: constantColors.secondary,),
          ],
        ),
      ),
    );
  }

  Widget phone(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
        width: Adaptive.w(MediaQuery.of(context).size.width*5),
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
              width: MediaQuery.of(context).size.width*.6,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                child: TextFormField(
                  keyboardType:TextInputType.number,
                  controller: phoneController,
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Phone',
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
            Icon(Icons.phone,color: constantColors.secondary,),
          ],
        ),
      ),
    );
  }

  Widget name(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
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
              width: MediaQuery.of(context).size.width*.6,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                child: TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Username',
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
            Icon(Icons.person,color: constantColors.secondary,),
          ],
        ),
      ),
    );
  }

  Widget forgotPassword(BuildContext context){
    return  Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
        onTap: (){
          Navigator.pushReplacement(context, PageTransition(child: const ForgotPassword(), type: PageTransitionType.rightToLeft));
        },
        child: const Text("Forgot Password ?",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      ),
    );
  }

  Widget login(BuildContext context){
    return InkWell(
      onTap: (){
        if(emailController.text.isEmpty||passwordController.text.isEmpty){
          Fluttertoast.showToast(msg: "Please Fill this fields",fontSize: 16,gravity: ToastGravity.BOTTOM);
        }
        else {
          if(!emailController.text.contains("@")){
            Fluttertoast.showToast(msg: "Write your email with a right format",fontSize: 16,gravity: ToastGravity.BOTTOM);
          }
          else{
            Provider.of<Authentication>(context, listen: false)
                .logIntoAccount(
                emailController.text.trim(), passwordController.text.trim())
                .then((_) =>
                Navigator.pushReplacement(context, PageTransition(
                    child:  const MenuScreen(),
                    type: PageTransitionType.rightToLeft)));
          }}
      },
      child: Container(
        height: MediaQuery.of(context).size.height*.08,
        width: MediaQuery.of(context).size.width*.5,
        decoration: BoxDecoration(
          color: constantColors.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(22)),)),
      ),
    );
  }

  Widget haveAnAccount(BuildContext context){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushReplacement(context, PageTransition(child: const LoginScreen(), type: PageTransitionType.rightToLeft));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text("Already have an account ?",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
              Text(" Login",style: TextStyle(color: constantColors.secondary,fontSize: 16,fontWeight: FontWeight.bold),),
            ],),
        )
      ],
    );
  }

  Widget or(BuildContext context){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            Fluttertoast.showToast(msg: "This Feature will be available soon!",gravity: ToastGravity.BOTTOM,);
          },
          child: Text("OR",style: TextStyle(color: constantColors.whiteColor,fontSize: 16,fontWeight: FontWeight.bold),),
        )
      ],
    );
  }

  Widget bottomBar(BuildContext context){
    return  Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
        color: Color(0x36000000),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Facebook(context),
          Google(context),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Facebook(BuildContext context){
    return InkWell(
      onTap: (){
        Provider.of<Authentication>(context, listen: false).signInWithFacebook(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset("images/facebook.png",height: 30,width: 30,),
            ),
            const Text("Facebook",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Google(BuildContext context){
    return InkWell(
      onTap: (){
        Provider.of<Authentication>(context, listen: false)
            .signInWithGoogle()
            .then((_) async {
          Provider.of<FirebaseOperations>(context,listen: false).createUserCollection(context,{
            'useruid':FirebaseAuth.instance.currentUser!.uid,
            'useremail':FirebaseAuth.instance.currentUser!.email,
            'username':FirebaseAuth.instance.currentUser!.displayName,
            'userimage':FirebaseAuth.instance.currentUser!.photoURL,
            'userphone':null,
            "useraddress":null,
          }).then((_) {
            Navigator.pushReplacement(context, PageTransition(child: const MenuScreen(), type: PageTransitionType.rightToLeft));
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 40.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset("images/google.png",height: 30,width: 30,),
            ),
            const Text("Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)
          ],
        ),
      ),
    );
  }

  Widget signUp(BuildContext context){
    return InkWell(
      onTap: (){
      if(emailController.text.isEmpty||nameController.text.isEmpty||passwordController.text.isEmpty||phoneController.text.isEmpty){
        Fluttertoast.showToast(msg: "Please Fill this fields",fontSize: 16,gravity: ToastGravity.BOTTOM);
      }
      else {
        if(nameController.text.length<8||!emailController.text.contains("@")||passwordController.text.length<8) {
          Fluttertoast.showToast(msg: "fill this fields with a right format",fontSize: 16,gravity: ToastGravity.BOTTOM);
        }
        else {
          Provider.of<Authentication>(context, listen: false)
              .createAccount(
              emailController.text.trim(), passwordController.text.trim(),
              nameController.text.trim())
              .then((_) async {
            Provider.of<FirebaseOperations>(context, listen: false)
                .createUserCollection(context, {
              'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
              'useremail': emailController.text,
              'username': nameController.text,
              'userimage': 'https://firebasestorage.googleapis.com/v0/b/ieeesystem.appspot.com/o/user.png?alt=media&token=e9f59c0f-317d-466e-ace1-a64e1283ebb3',
              "userphone":phoneController.text,
              "useraddress":null,
            });
            Navigator.pushReplacement(context, PageTransition(
                child: const LoginScreen(),
                type: PageTransitionType.leftToRight));
          });
        }}},
      child: Container(
        height: MediaQuery.of(context).size.height*.08,
        width: MediaQuery.of(context).size.width*.5,
        decoration: BoxDecoration(
          color: constantColors.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(22)),)),
      ),
    );
  }

  Widget haveNotAnAccount(BuildContext context){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushReplacement(context, PageTransition(child: const RegisterScreen(), type: PageTransitionType.rightToLeft));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              const Text("Don't have an account ?",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
              Text(" Register",style: TextStyle(color: constantColors.secondary,fontSize: 16,fontWeight: FontWeight.bold),),
            ],),
        )
      ],
    );
  }

  Widget resetInformation(BuildContext context){
    return Column(
      children: [
        Image.asset("images/forgot.png",height: 250,),
        const Padding(
          padding: EdgeInsets.only(left: 25,top: 15),
          child: Align(alignment: Alignment.topLeft,child: Text("Reset Password",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),)),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25,top: 15),
          child: Align(alignment: Alignment.topLeft,child: Text("Enter the email associated with your\naccount we'll send an email with\ninstructions to reset your password.",style: TextStyle(color: Colors.grey,fontSize: 18),)),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25,top: 15),
          child: Align(alignment: Alignment.topLeft,child: Text("Email Address",style: TextStyle(color: Colors.grey,fontSize: 14),)),
        ),
      ],
    );
  }

  Widget resetPassword(BuildContext context){
    return InkWell(
      onTap: (){
        if(emailController.text.isEmpty){
          Fluttertoast.showToast(msg: "Please Fill this fields",fontSize: 16,gravity: ToastGravity.BOTTOM);
        }
        else {
          if(!emailController.text.contains("@")) {
            Fluttertoast.showToast(msg: "fill this fields with a right format",fontSize: 16,gravity: ToastGravity.BOTTOM);
          }
          else {
          FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text).whenComplete(() => Navigator.pushReplacement(context, PageTransition(
              child: const LoginScreen(),
              type: PageTransitionType.leftToRight)));
          }}},
      child: Container(
        height: MediaQuery.of(context).size.height*.08,
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