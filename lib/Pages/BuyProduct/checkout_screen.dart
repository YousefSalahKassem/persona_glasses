import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/BuyProduct/product_helper.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
import 'package:persona/Services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatelessWidget {
  double Quantity;

  CheckoutScreen(this.Quantity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title:const Text("Checkout",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Padding(
            padding: EdgeInsets.only(top: 15.0,left: 15),
            child: Text("Description",style: TextStyle(color: Colors.grey,fontSize: 14),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0,left: 15),
            child: Provider.of<ProductHelper>(context,listen: false).product(context,Quantity),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30.0,left: 15),
            child: Text("Personal Information",style: TextStyle(color: Colors.grey,fontSize: 14),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0,left: 15,right:15),
            child: Provider.of<ProductHelper>(context,listen: false).information(context),
          ),
          const SizedBox(height: 20,)

        ],
      ),),
      bottomNavigationBar: Wrap(
        children: [
          Container(
            decoration:  BoxDecoration(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                color: constantColors.card
            ) ,
            child:  Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('SubTotal',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text((Quantity*120).toString(),style:const TextStyle(color: Colors.white,fontSize: 16),),
                    ],),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0,left: 25),
                  child: Divider(color: Colors.grey.shade500,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:const [
                      Text('Tas & Fee',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('\$3.50',style: TextStyle(color: Colors.white,fontSize: 16),),
                    ],),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0,left: 25),
                  child: Divider(color: Colors.grey.shade500,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:const [
                      Text('Delivery',style: TextStyle(color: Colors.white,fontSize: 16),),
                      Text('\$10.10',style: TextStyle(color: Colors.white,fontSize: 16),),
                    ],),
                ),
                const Padding(
                  padding:  EdgeInsets.only(right: 25.0,left: 25),
                  child: Divider(color: Colors.white,thickness: 2,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 25,right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                      Text('\$${(((120*Quantity)+3.50+10.10)).toStringAsFixed(2)}',style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                    ],),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: (){
                      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
                        Provider.of<FirebaseOperations>(context,listen: false).makeAnOrder(context, {
                          "uid":FirebaseAuth.instance.currentUser!.uid,
                          "time":DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now()),
                          "quantity":Quantity,
                          "totalPrice":(120*Quantity),
                          "phone":value["userphone"],
                          "address":value["useraddress"],
                        }).whenComplete(() =>Navigator.push(context, MaterialPageRoute(builder: (context)=>const MenuScreen())));
                      } );
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20)),color: constantColors.secondary,),
                      child: Center(child: Text("Checkout",style: TextStyle(fontSize: Adaptive.sp(18),fontWeight: FontWeight.bold,color: Colors.white),)),
                    ),
                  ),),
                ),
                const SizedBox(height: 20,),
              ],),
          ),
        ],
      ),
    );
  }
  }



