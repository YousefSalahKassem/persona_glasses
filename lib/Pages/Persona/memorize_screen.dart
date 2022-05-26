import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';

import '../../Constants/constants_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MemorizeScreen extends StatefulWidget {
  final BluetoothDevice server;

  const MemorizeScreen({Key? key,required this.server}) : super(key: key);

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
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  static final clientID = 0;
  var connection; //BluetoothConnection
  List<_Message> messages = [];
  final ScrollController listScrollController =  ScrollController();
  bool isConnecting = true;
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected()) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
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
                  _sendMessage("Memorize#"+description.text+"#");
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                  child: Center(child: Text("Send",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                ),
              ),),
            ),
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

  void _sendMessage(String text) async {
    text = text.trim();


    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  bool isConnected() {
    return connection != null && connection.isConnected;
  }

}
