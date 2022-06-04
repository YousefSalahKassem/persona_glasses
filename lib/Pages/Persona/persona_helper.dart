import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:lottie/lottie.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Model/category_model.dart';
import 'package:persona/Pages/Persona/face_recognition.dart';
import 'package:persona/Pages/Persona/memorize_screen.dart';
import 'package:persona/Pages/Persona/recongition_screen.dart';
import 'package:persona/Pages/Persona/stt_screen.dart';
import 'package:persona/Pages/Persona/tts_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:translator/translator.dart';

import '../WifiScreen/discovery_page.dart';

class PersonaHelper with ChangeNotifier{
  final translator = GoogleTranslator();
  ConstantColors constantColors=ConstantColors();
  String output='';
  TextEditingController nameController=TextEditingController();


  Widget information(BuildContext context,String title){
    return  Wrap(
      children:[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, "+FirebaseAuth.instance.currentUser!.displayName!.substring(0,FirebaseAuth.instance.currentUser!.displayName!.indexOf(" ")),style: TextStyle(color: Colors.white,fontSize: Adaptive.sp(20),fontWeight: FontWeight.bold),),
                  SizedBox(height:MediaQuery.of(context).size.height*.015 ,),
                  SizedBox(width: MediaQuery.of(context).size.width*.55,child: Text(title,style: TextStyle(color: Colors.grey,fontSize: Adaptive.sp(16),),maxLines: 4,)),
                ],),
              Lottie.asset("images/hiieee.json",height: Adaptive.h(30),width:Adaptive.w(40) ),
            ],
          ),
        ),

      ],
    );
  }

  Widget category(BuildContext context){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    
    return Container(
      height: height*.65,
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 8,
        children: List.generate(categories.length, (index) {
          return InkWell(
            onTap: () async {
              if(categories[index].name=="Memorize"){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const MemorizeScreen();
                    },
                  ),
                );
              }
              else if(categories[index].name=="Text Recognition"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const RecognitionScreen()));
              }
              else if(categories[index].name=="Text To Speech"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const TTSScreen()));
              }
              else if(categories[index].name=='Face Recognition'){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const FaceRecognition()));
              }
              else{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const STTScreen()));
              }
            },
            child: Center(
              child: Card(
                color: constantColors.blueGreyColor,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(categories[index].image,height: height*.2, width: width*.3,),
                      Text(categories[index].name,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget descriptions(BuildContext context,String _text){
    TextEditingController description = TextEditingController(text: _text);
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width*5,
        height: 200,
        decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(40)),
            border: Border.all(color: constantColors.secondary)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                  child: TextFormField(
                    maxLines: 10,
                    controller: description,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Description...',
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
        ),
      ),
    );
  }

  Widget send(BuildContext context,String text){
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Align(alignment: Alignment.topCenter,child: InkWell(
        onTap: (){
          FirebaseFirestore.instance.collection('memorize').doc(FirebaseAuth.instance.currentUser!.uid).set(
              {
                "message":text
              });
        },
        child: Container(
          height: 40,
          width: 150,
          decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
          child: Center(child: Text("Send",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
        ),
      ),),
    );

  }

  Widget result(BuildContext context,TextEditingController editDescription){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width*5,
        height: Adaptive.h(35),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: Border.all(color: constantColors.secondary)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width*.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                  child: Text(editDescription.text,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String translate(BuildContext context,String result,String code) {
    notifyListeners();
    translator
        .translate(result,from: "en", to: code)
        .then((result) async {
      await Future.delayed(Duration(milliseconds: 500));
      return output = result.toString();
    });
    return output;
  }

  Widget request(BuildContext context){
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height*.3,
          width: MediaQuery.of(context).size.width*.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/persona-smart-glasses.appspot.com/o/90176576_3438753076142125_7490368800391430144_n.jpg?alt=media&token=5b1f4144-3a29-40bf-926d-992c568d30ac'),fit: BoxFit.cover)
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*.08,),
        name(context),
        SizedBox(height: MediaQuery.of(context).size.height*.08,),
        Container(
          height: MediaQuery.of(context).size.height*.07,
          width: MediaQuery.of(context).size.width*.5,
          decoration: BoxDecoration(
            color: constantColors.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(child: Text("Send",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(22)),)),
        )
      ],
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

}
