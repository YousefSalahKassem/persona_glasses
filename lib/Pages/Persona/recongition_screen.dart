import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:persona/Pages/Persona/result_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';


class RecognitionScreen extends StatefulWidget {
  const RecognitionScreen({Key? key}) : super(key: key);

  @override
  _RecognitionScreenState createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  String imagePath = "asd";
  late File myImagePath;
  String finalText = ' ';
  bool isLoaded = false;
  final translator = GoogleTranslator();
  String code="es";
  String output='';
  String language="Spanish";
  String translate(){
    translator.translate(finalText, to: code).then((result) {setState(() {output=result.text;});
    }

    );
    return output;

  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
    return Scaffold(
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "Add your image that you need to recognize,You have option to translate or listen,After recognition"),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 15,right: 15,),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  border: Border.all(
                      color: constantColors.secondary
                  )
              ),
              child: isLoaded
                  ? Image.file(
                myImagePath,
                fit: BoxFit.cover,
              )
                  : Center(child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('textRecognition').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return snapshot.data!.data()!['image'].toString().isEmpty?const Text('upload Image',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):Image.network(snapshot.data!.data()!['image'],fit: BoxFit.cover,);
                    }
                    else {
                      return Container();
                    }
                  })),
            ),
            InkWell(
              onTap: (){
                getImage();
                Future.delayed(const Duration(seconds: 5), () {
                  getText(imagePath).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultScreen(finalText)))
                  );
                });
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 100,
                      margin: EdgeInsets.only(left: 20,top: 10),
                      decoration: BoxDecoration(
                        color: constantColors.primary,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(child: Text('upload',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    ),
                    PopupMenuButton(
                        color:Colors.white,
                        key: _key,
                        itemBuilder: (context){
                          return[
                            PopupMenuItem(child: const Text("Spanish",),onTap:(){
                              setState(() {
                                language="Spanish";
                                code="es";
                                translate();
                              });
                            } ,),
                            PopupMenuItem(child: const Text("French",),onTap:(){
                              setState(() {
                                language="French";
                                code="fr";
                              });
                            } ,),
                            PopupMenuItem(child: const Text("Italy",),onTap:(){
                              setState(() {
                                language="Italy";
                                code="it";
                              });
                            } ,),
                          ];
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(
        backgroundColor: constantColors.secondary,
        onPressed: (){
            Future.delayed(const Duration(seconds: 5), () {
              FirebaseFirestore.instance.collection('textRecognition').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
                print(value['image']);
                getTextFromUrl(value['image']).whenComplete(() {
                  translator.translate(finalText, to: code).then((result) {
                    FirebaseFirestore.instance.collection('textRecognition').doc(FirebaseAuth.instance.currentUser!.uid).update(
                        {
                          'image':'',
                          'result':finalText+"|"+language+":"+result.text+"#"
                        });
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultScreen(finalText)));
                  });
                }
                );
              } );

            });
        },
        child: const Icon(Icons.document_scanner,color: Colors.white,),
      ),
    );
  }

  Future getTextFromUrl(String path) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(Uri.parse(path));
    await file.writeAsBytes(response.bodyBytes);
    final inputImage = InputImage.fromFile(file);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _reconizedText =
    await textDetector.processImage(inputImage);

    for (TextBlock block in _reconizedText.blocks) {
      for (TextLine textLine in block.lines) {
        for (TextElement textElement in textLine.elements) {
          setState(() {
            finalText = finalText + " " + textElement.text;
          });
        }

        finalText = finalText + '\n';
      }
    }
  }

  void getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });
  }

  Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _reconizedText =
    await textDetector.processImage(inputImage);

    for (TextBlock block in _reconizedText.blocks) {
      for (TextLine textLine in block.lines) {
        for (TextElement textElement in textLine.elements) {
          setState(() {
            finalText = finalText + " " + textElement.text;
          });
        }

        finalText = finalText + '\n';
      }
    }
  }
}