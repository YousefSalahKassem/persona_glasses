import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Social%20Media/social_helper.dart';
import 'package:provider/provider.dart';

import '../../Utils/upload_post.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: constantColors.secondary,
        onPressed: (){
        Provider.of<UploadPost>(context,listen: false).selectPostImage(context,"posts");
      },child: Icon(Icons.add,color: constantColors.whiteColor,size: 35) ,),
      body: SingleChildScrollView(child: Provider.of<SocialHelper>(context,listen: false).feedBody(context)),
    );
  }
}
