import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/SupportScreen/support_helper.dart';
import 'package:provider/provider.dart';

import '../Social Media/social_helper.dart';

class DetailsScreen extends StatelessWidget {
  DocumentSnapshot documentSnapshot;


  DetailsScreen(this.documentSnapshot);

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
      backgroundColor:constantColors.background,
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Provider.of<SupportHelper>(context,listen: false).technicalPost(context,documentSnapshot),
      )),
    );
  }
}
