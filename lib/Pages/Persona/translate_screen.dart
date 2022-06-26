import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Persona/persona_helper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:translator/translator.dart';

// ignore: must_be_immutable
class TranslateScreen extends StatefulWidget {
  String result;
  TranslateScreen(this.result, {Key? key}) : super(key: key);

  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final translator = GoogleTranslator();
  String language="Arabic";
  String code="ar";
  String output='';
  ConstantColors constantColors=ConstantColors();
  String translate(){
    translator.translate(widget.result, to: code).then((result) {setState(() {output=result.text;});});
    return output;
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
    return Scaffold(
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Provider.of<PersonaHelper>(context,listen: false).information(context, "Add your image that you need to recognize,You have option to translate or listen,After recognition"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: (){
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                      child: Center(child: Text("Default",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                    ),
                  ),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.asset("images/change.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: (){
                      _key.currentState!.showButtonMenu();

                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                      child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(language,style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),),
                          PopupMenuButton(
                            key: _key,
                            itemBuilder: (context){
                              return[
                                PopupMenuItem(child: const Text("Arabic",),onTap:(){
                                  setState(() {
                                    language="Arabic";
                                    code="ar";
                                    translate();
                                  });
                                } ,),
                                PopupMenuItem(child: const Text("Japanese",),onTap:(){
                                  setState(() {
                                    language="Japanese";
                                    code="zh-cn";
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
                      )),
                    ),
                  ),),
                ),
              ],
            ),
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width*.6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                      child: Text(widget.result,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    ),
                  ),
                ),
              ),
            ),
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width*.6,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 1.0,right: 1.0),
                      child: Text(translate(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Adaptive.h(2),),
          ],
        ),
      ),
    );
  }
}
