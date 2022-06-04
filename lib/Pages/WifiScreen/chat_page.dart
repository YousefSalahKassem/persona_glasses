import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Constants/constants_color.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;
  final String wifi;
  // ignore: use_key_in_widget_constructors
  const ChatPage({required this.server,required this.wifi});

  @override
  _ChatPage createState() =>  _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  static final clientID = 0;
  String _messageBuffer = '';
  var connection; //BluetoothConnection
  final TextEditingController password = TextEditingController();
  final ScrollController listScrollController =  ScrollController();
  ConstantColors constantColors=ConstantColors();
  bool isConnecting = true;
  bool isDisconnecting = false;
  final info = NetworkInfo();

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
      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
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
    final TextEditingController name = TextEditingController(text: widget.wifi.toString());

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
                _sendMessage(name.text+"#"+password.text+"#"+FirebaseAuth.instance.currentUser!.uid+"#");
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

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        _messageBuffer = dataString.substring(index);
        _messageBuffer=="connected"?Navigator.pop(context):null;
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
          0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
      _messageBuffer=="connected"?Navigator.pop(context):null;
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    password.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text));
        await connection.output.allSent;
        Fluttertoast.showToast(msg: "Wifi Connecting",gravity: ToastGravity.BOTTOM,textColor: Colors.white,backgroundColor: constantColors.secondary);
        // Navigator.pop(context);
        print(text);
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