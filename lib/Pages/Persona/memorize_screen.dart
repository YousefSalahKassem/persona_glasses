import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MemorizeScreen extends StatefulWidget {
  const MemorizeScreen({Key? key}) : super(key: key);

  @override
  _MemorizeScreenState createState() => _MemorizeScreenState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}


class _MemorizeScreenState extends State<MemorizeScreen> {
  ConstantColors constantColors=ConstantColors();
  late stt.SpeechToText _speech;
  late  bool _isListening = false;
  String? _text;
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

  }


  @override
  Widget build(BuildContext context) {
    TextEditingController description = TextEditingController(text: _text);

    return Scaffold(
      backgroundColor:constantColors.background,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "Don't worry about forget anything,\nadd your notes, it will be shown on glasses."),
            SizedBox(height: Adaptive.h(5),),
            Padding(
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
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (String value){
                              FirebaseFirestore.instance.collection('memorize').doc(FirebaseAuth.instance.currentUser!.uid).set(
                                  {
                                    "message":value
                                  });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Press the button and start speaking',
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
            ),
            SizedBox(height: Adaptive.h(5),),
            Provider.of<PersonaHelper>(context,listen: false).send(context, description.text)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: constantColors.secondary,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: constantColors.secondary,
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

}
