import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/BuyProduct/product_helper.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
import 'package:persona/Services/firebase_operations.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  double Quantity;

  CheckoutScreen(this.Quantity, {Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? paymentIntentData;

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
            child: Provider.of<ProductHelper>(context,listen: false).product(context,widget.Quantity),
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
                      Text((widget.Quantity*120).toString(),style:const TextStyle(color: Colors.white,fontSize: 16),),
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
                      Text('\$${(((120*widget.Quantity)+3.50+10.10)).toStringAsFixed(2)}',style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
                    ],),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Align(alignment: Alignment.topCenter,child: InkWell(
                    onTap: ()async{
                      await makePayment(((120*widget.Quantity.toInt()+4+10)*100).toString(), 'USD', context);
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

  Future<void> makePayment(String amount, String currency,BuildContext context) async {
    try {

      paymentIntentData =
      await createPaymentIntent(amount, currency); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE')).then((value){
      });


      ///now finally display payment sheeet
      displayPaymentSheet(context);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(BuildContext context) async {

    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue){


        print('payment intent'+paymentIntentData!['id'].toString());
        print('payment intent'+paymentIntentData!['client_secret'].toString());
        print('payment intent'+paymentIntentData!['amount'].toString());
        print('payment intent'+paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;

      }).onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51LAOgiKbfWbA0WIcOAT2s0AXwzYfwdTWroL3KA7dNsEDqiwps6LN6Uo3L6f1lrJDKVC7g28jua9rBmfocRJAiBqB00huQKpJgq',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
}



