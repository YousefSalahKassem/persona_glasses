import 'package:flutter/material.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../Constants/constants_color.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSScreen extends StatefulWidget {
  const TTSScreen({Key? key}) : super(key: key);

  @override
  _TTSScreenState createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  ConstantColors constantColors=ConstantColors();
  bool isSpeaking = false;
  final TextEditingController _controller = TextEditingController();
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
    super.initState();
    initializeTts();
  }

  void speak() async {



    if (_controller.text.isNotEmpty) {
      await _flutterTts.speak(_controller.text);
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
      backgroundColor:constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "After finish writing, you can start listening. "),
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
                        controller: _controller,
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
        ),
            SizedBox(height: Adaptive.h(5),),
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
                  child: Center(child: Text("Speak",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                ),
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
