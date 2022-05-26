import 'package:flutter/material.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/BuyProduct/checkout_screen.dart';
import 'package:persona/Pages/BuyProduct/product_helper.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ConstantColors constantColors=ConstantColors();

  @override
  void initState() {
    Provider.of<ProductHelper>(context,listen: false).q=double.parse("1.0");
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    Provider.of<ProductHelper>(context,listen: false).q;
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:constantColors.background,
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50,),
            Align(alignment: Alignment.topCenter,child: Image.asset("images/glass.png")),
            const Padding(
              padding: EdgeInsets.only(top: 15.0,left: 15),
              child: Text("Persona Smart Glasses",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0,left: 15),
              child: Text("120\$",style: TextStyle(fontSize: 18,color: Colors.grey,fontWeight: FontWeight.w500),),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0,left: 15),
              child: Text("Description",style: TextStyle(color: Colors.grey,fontSize: 14),),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0,left: 15),
              child: Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Align(alignment: Alignment.topCenter,child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      if(Provider.of<ProductHelper>(context, listen: false).q<=1){
                      }
                      else {
                        setState(() {
                          Provider.of<ProductHelper>(context, listen: false)
                              .minus(context);
                        });
                      }},
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),color: Colors.white,),
                      child: const Icon(Icons.remove,color:Colors.lightBlue),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Text(Provider.of<ProductHelper>(context,listen: false).getData(context, double.parse("1.0")),style: const TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 16,decoration: TextDecoration.none),),
                  const SizedBox(width: 5,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        Provider.of<ProductHelper>(context, listen: false)
                            .plus(context);
                      });
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration:  BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)),color: constantColors.secondary,),
                      child: const Icon(Icons.add,color:Colors.white),
                    ),
                  ),
                ],
              ),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(alignment: Alignment.topCenter,child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckoutScreen(Provider.of<ProductHelper>(context,listen: false).q)));
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
          ],
        ),
      ) ,
    );
  }
}
