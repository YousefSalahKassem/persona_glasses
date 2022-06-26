import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductHelper with ChangeNotifier{
  late double q;
  bool enable=false;
  ConstantColors constantColors=ConstantColors();

  String getData(BuildContext context,double value){

    notifyListeners();
    return q.toString();
  }

  Future minus(BuildContext context)async{
    q--;
    getData(context, q);
    notifyListeners();
  }

  Future plus(BuildContext context)async{
    q++;
    getData(context, q);
    notifyListeners();
  }

  Widget product(BuildContext context,double Quantity){
    return Container(
      height: MediaQuery.of(context).size.height*.3,
      width: MediaQuery.of(context).size.width*.45,
      decoration: const BoxDecoration(
        color: Color(0x1dffffff),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/glass.png",height: 120,width: 120,),
            Text("Persona Smart Glasses",textAlign: TextAlign.center,maxLines: 2,style: TextStyle(color: constantColors.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
            Padding(
              padding:  EdgeInsets.only(top: Adaptive.h(2),left: Adaptive.w(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text((Quantity.toInt()*120).toString()+"\$",textAlign: TextAlign.center,maxLines: 2,style: TextStyle(color: constantColors.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
                  Text("X"+Quantity.toInt().toString(),textAlign: TextAlign.center,maxLines: 2,style: TextStyle(color: constantColors.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget information (BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("users").where("useruid",isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else {
          return SizedBox(
          height: MediaQuery.of(context).size.height*.3,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return Container(
                height: MediaQuery.of(context).size.height*.25,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0x1dffffff),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.home,color: Colors.white,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10.0),
                      child: Text(documentSnapshot["useraddress"]??'',maxLines: 3,style: TextStyle(color: constantColors.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0,left: 20,right: 20,bottom: 10.0),
                      child: Text(documentSnapshot["userphone"]??'',maxLines: 3,style: TextStyle(color: constantColors.whiteColor,fontSize: 18,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child:  Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                color: constantColors.secondary,
                                borderRadius: const BorderRadius.all(Radius.circular(50))
                            ),
                            child: const Icon(Icons.check,color: Colors.white,size: 20,)),
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ,
          ),
        );
        }
      }
    );
      }

  Future<void> makePayment({required String amount, required String currency}) async {
    try {
      Map<String, dynamic> paymentIntentData;

      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              applePay: true,
              googlePay: true,
              testEnv: true,
              merchantCountryCode: 'US',
              merchantDisplayName: 'Prospects',
              customerId: paymentIntentData!['customer'],
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
            ));
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'sk_test_51LAOgiKbfWbA0WIcOAT2s0AXwzYfwdTWroL3KA7dNsEDqiwps6LN6Uo3L6f1lrJDKVC7g28jua9rBmfocRJAiBqB00huQKpJgq',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  }

