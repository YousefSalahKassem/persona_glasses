import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/SupportScreen/support_helper.dart';
import 'package:provider/provider.dart';

import '../../Utils/upload_post.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Support",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22),),
      ),
      backgroundColor: constantColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.secondary,
        onPressed: (){
          Provider.of<UploadPost>(context,listen: false).selectPostImage(context,"support");
        },child: Icon(Icons.add,color: constantColors.whiteColor,size: 35) ,),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Provider.of<SupportHelper>(context,listen: false).feedBody(context)
          ],
        ),
      ),
    );
  }
}
