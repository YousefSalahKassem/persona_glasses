import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:provider/provider.dart';
import 'chat_page.dart';
import 'discovery_page.dart';



class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => new _MainPage();
}

class _MainPage extends State<MainPage> {
  ConstantColors constantColors=ConstantColors();
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final info = NetworkInfo();
  String _address = "...";
  String _name = "...";

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled==true) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
        title: const Text('Flutter Bluetooth Serial'),
        backgroundColor: constantColors.primary,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: const Text('General',style: TextStyle(color: Colors.white),)),
            SwitchListTile(
              title: const Text('Enable Bluetooth',style: TextStyle(color: Colors.white)),
              value: _bluetoothState.isEnabled,
              activeColor: constantColors.primary,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              title: const Text('Bluetooth status',style: TextStyle(color: Colors.white)),
              subtitle: Text(_bluetoothState.toString(),style: TextStyle(color: Colors.white)),
              trailing: RaisedButton(
                child: const Text('Settings'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                },
              ),
            ),
            ListTile(
              title: const Text('Local adapter address',style: TextStyle(color: Colors.white)),
              subtitle: Text(_address,style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: const Text('Local adapter name',style: TextStyle(color: Colors.white)),
              subtitle: Text(_name,style: TextStyle(color: Colors.white)),
              onLongPress: null,
            ),
            Divider(),
            ListTile(
              title: TextButton(
                  child:
                  Text('Connect to paired device to chat with ESP32',style: TextStyle(color: constantColors.primary)),
                  onPressed: () async {
                    final BluetoothDevice selectedDevice =
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DiscoveryPage();
                        },
                      ),
                    );

                    if (selectedDevice != null) {
                      print('Discovery -> selected ' + selectedDevice.address);
                      _startChat(context, selectedDevice);
                    } else {
                      print('Discovery -> no device selected');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) async{
    var ssid=await info.getWifiName();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server,wifi:ssid.toString() ,);
        },
      ),
    );
  }
}