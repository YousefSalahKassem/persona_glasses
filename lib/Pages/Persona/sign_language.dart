import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import '../../Constants/constants_color.dart';
import 'package:http/http.dart' as http;

class SignLanguage extends StatefulWidget {
  const SignLanguage({Key? key}) : super(key: key);

  @override
  State<SignLanguage> createState() => _SignLanguageState();
}

class _SignLanguageState extends State<SignLanguage> {
  List? _outputs;
  XFile? _image;
  bool _loading = false;
  String _name='';
  
  pickImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(XFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }
  
  classifyImageFromUrl(XFile image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    FirebaseFirestore.instance.collection('signLanguage').doc(FirebaseAuth.instance.currentUser!.uid).update(
        {
          'result':output![0]["label"].toString().substring(2)+"#"
        });

    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "images/model_unquant.tflite",
      labels: "images/labels.txt",
    );
  }

  @override
  void initState() {
    super.initState();
    _loading = true;

    FirebaseFirestore.instance.collection('signLanguage').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value)async{
      var rng = Random();
// get temporary directory of device.
      Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
      String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
      File file =  File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
      http.Response response = await http.get(Uri.parse(value['image']));
// write bodyBytes received in response to file.
      await file.writeAsBytes(response.bodyBytes);

      XFile xFile=XFile(file.path);
      classifyImageFromUrl(xFile);
    });

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      body: Column(
        children: [
          Provider.of<PersonaHelper>(context,listen: false).information(context, "I'm persona bot, put image you want to translate"),
          SizedBox(height: MediaQuery.of(context).size.height*.01,),
          _image == null ? Container(
            height: MediaQuery.of(context).size.height*.3,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('signLanguage').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return snapshot.data!.data()!['image'].toString().isEmpty?const Text('upload Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):Image.network(snapshot.data!.data()!['image'],fit: BoxFit.cover,);
                  }
                  else return Container();
                }),
          ) : SizedBox(
              height: MediaQuery.of(context).size.height*.3,
              child: Image.file(File(_image!.path),fit: BoxFit.cover,),),
          const SizedBox(
            height: 20,
          ),
          _outputs != null
              ? Text(
            "${_outputs![0]["label"].toString().substring(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: const Icon(Icons.image),
      ),
    );
  }

}

