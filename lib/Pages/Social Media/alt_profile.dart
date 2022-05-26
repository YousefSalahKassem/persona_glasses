import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/Social%20Media/alt_profile_helper.dart';
import 'package:provider/provider.dart';

class AltProfile extends StatelessWidget {
final String userId;
const AltProfile(this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:constantColors.blueGreyColor,
        centerTitle: true,
        title: const Text("Persona",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*.52,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: constantColors.blueGreyColor,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
              ),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                  builder:(context,snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    else{
                      return Column(
                        children: [
                          Provider.of<AltProfileHelper>(context,listen: false).Information(context,snapshot,userId),
                        ],
                      );
                    }
                  }
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                builder:(context,snapshot){
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else{
                    return Provider.of<AltProfileHelper>(context,listen: false).footerProfile(context,snapshot,userId);
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
