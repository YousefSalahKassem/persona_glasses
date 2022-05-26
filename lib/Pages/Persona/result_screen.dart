import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:persona/Pages/Persona/translate_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  String result;
  ResultScreen(this.result, {Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  ConstantColors constantColors=ConstantColors();
  bool isSpeaking = false;

  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeTts();
  }

  void speak() async {
    if (widget.result.isNotEmpty) {
      await _flutterTts.speak(widget.result);
    }
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "Add your image that you need to recognize,You have option to translate or listen,After recognition"),
            SizedBox(height: Adaptive.h(2),),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width*5,
                height: Adaptive.h(35),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
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
                          child: Text(widget.result,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Adaptive.h(2),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TranslateScreen(widget.result)));
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                      child: Center(child: Text("Translate",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                    ),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: (){
                      isSpeaking ? stop() : speak();
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                      child: Center(child: Text("Listen",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                    ),
                  ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
