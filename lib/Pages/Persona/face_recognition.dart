import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({Key? key}) : super(key: key);

  @override
  State<FaceRecognition> createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  ConstantColors constantColors=ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.background,
      body: Column(
        children: [
          Provider.of<PersonaHelper>(context,listen: false).information(context, "I'm persona bot, There is request for known face."),
          SizedBox(height: MediaQuery.of(context).size.height*.01,),
          Provider.of<PersonaHelper>(context,listen: false).request(context),

        ],
      ),
    );
  }
}
