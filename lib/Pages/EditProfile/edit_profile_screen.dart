import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Pages/EditProfile/edit_profile_helper.dart';
import 'package:persona/Pages/HomeScreen/menu_screen.dart';
import 'package:provider/provider.dart';

import '../../Services/firebase_operations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String address = '' ;
  final Completer<GoogleMapController> _controller = Completer();
  Future<Position> _getUserCurrentLocation() async {


    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }


  final List<Marker> _markers =  <Marker>[];

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );


  List<Marker> list = const [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.6844, 73.0479),
        infoWindow: InfoWindow(
            title: 'some Info '
        )
    ),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(list);
    //loadData();
  }

  loadData(){
    _getUserCurrentLocation().then((value) async {
      _markers.add(
          Marker(
              markerId: const MarkerId('SomeId'),
              position: LatLng(value.latitude ,value.longitude),
              infoWindow:  InfoWindow(
                  title: address
              )
          )
      );

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex =  CameraPosition(
        target: LatLng(value.latitude ,value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,right: 15,left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(alignment: Alignment.center,child: Provider.of<EditProfileHelper>(context,listen: false).changeImage(context)),
              const SizedBox(height: 20,),
              const Text("Personal Information",style: TextStyle(color: Colors.grey,fontSize: 14),),
              const SizedBox(height: 25,),
              const Text("First Name",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 10,),
              Provider.of<EditProfileHelper>(context,listen: false).firstName(context),
              const SizedBox(height: 15,),
              const Text("Last Name",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).lastName(context),
              const SizedBox(height: 10,),
              const Text("Email",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).email(context),
              const SizedBox(height: 10,),
              const Text("Phone Number",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).phone(context),
              const SizedBox(height: 20,),
              Container(
                height: MediaQuery.of(context).size.height * .4,
                margin: const EdgeInsets.only(bottom: 15
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      initialCameraPosition: _kGooglePlex,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller){
                        _controller.complete(controller);
                      },
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: FloatingActionButton(onPressed:(){
                        _getUserCurrentLocation().then((value) async {
                          _markers.add(
                              Marker(
                                  markerId: const MarkerId('SomeId'),
                                  position: LatLng(value.latitude ,value.longitude),
                                  infoWindow:  InfoWindow(
                                      title: address
                                  )
                              )
                          );
                          final GoogleMapController controller = await _controller.future;

                          CameraPosition _kGooglePlex =  CameraPosition(
                            target: LatLng(value.latitude ,value.longitude),
                            zoom: 14,
                          );
                          controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

                          List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude ,value.longitude);


                          final add = placemarks.first;
                          address = add.locality.toString() +" "+add.administrativeArea.toString()+" "+add.subAdministrativeArea.toString()+" "+add.country.toString();

                          setState(() {

                          });
                        });
                      } ,child: const Icon(Icons.location_on,color: Colors.white,),backgroundColor: constantColors.primary,)
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Address",style: TextStyle(color: Colors.grey),),
              const SizedBox(height: 15,),
              Provider.of<EditProfileHelper>(context,listen: false).address(context,address),
              const SizedBox(height: 35,),
              Provider.of<EditProfileHelper>(context,listen: false).resetPassword(context),
              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Provider.of<EditProfileHelper>(context,listen: false).editInfo(context);
      },backgroundColor: constantColors.secondary,child: Icon(Icons.save,color: constantColors.whiteColor,size: 35,),),
    );
  }
}
