import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  // ignore: use_key_in_widget_constructors
  const ChatPage({required this.server});

  @override
  _ChatPage createState() =>  _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  var connection; //BluetoothConnection
  List<_Message> messages = [];
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final ScrollController listScrollController =  ScrollController();
  ConstantColors constantColors=ConstantColors();
  bool isConnecting = true;
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

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
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
          backgroundColor: constantColors.secondary,
          centerTitle: true,
          elevation: 0,
          title: const Text("Login Wifi",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
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
                          controller: name,
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
            ),
            const SizedBox(height: 20,),
            Padding(
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
                          controller: password,
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
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                _sendMessage("Init#"+name.text+"#"+password.text+"##");
                Fluttertoast.showToast(msg: "Wifi Connecting",gravity: ToastGravity.BOTTOM,textColor: Colors.white,backgroundColor: constantColors.secondary);
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height*.07,
                width: MediaQuery.of(context).size.width*.5,
                decoration: BoxDecoration(
                  color: constantColors.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(child: Text("Add Wifi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: Adaptive.sp(22)),)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _sendMessage(String text) async {
    text = text.trim();
    name.clear();
    password.clear();

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