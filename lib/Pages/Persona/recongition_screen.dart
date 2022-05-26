import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:persona/Pages/Persona/result_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';


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
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();

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
                  : Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("images/upload.png"),
                      const SizedBox(height: 10,),
                      const Text("Drag & Drop",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      const Text("Your images here or Upload from gallery",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 16),),
                    ],
                  )),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(
          backgroundColor: constantColors.secondary,
          onPressed: (){
            getImage();
            Future.delayed(const Duration(seconds: 5), () {
              getText(imagePath).whenComplete(() => Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultScreen(finalText)))
              );
            });
          },
          child: const Icon(Icons.document_scanner,color: Colors.white,),
      ),
    );
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

  // this is for getting the image form the gallery
  void getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });
  }
}