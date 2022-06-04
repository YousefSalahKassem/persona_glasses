import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persona/Constants/constants_color.dart';
import 'package:persona/Model/gallery_model.dart';
import 'package:persona/Pages/HomeScreen/home_helper.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    Provider.of<HomeHelper>(context,listen: false).getAllImages();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors=ConstantColors();
    return Scaffold(
      backgroundColor: constantColors.background,
      body: SingleChildScrollView(
        child: Column(
          children:  [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("My Album",style: TextStyle(color: constantColors.whiteColor,fontWeight: FontWeight.bold,fontSize: 22),),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child:IconButton(icon: const Icon(Icons.cloud_upload,color: Colors.white,),onPressed: (){
                    setState(() {
                      Provider.of<HomeHelper>(context,listen: false).pickUploadPostImage(context, ImageSource.gallery).whenComplete(() {
                        setState(() {
                        GalleryModel galleryModel=GalleryModel(image: Provider.of<HomeHelper>(context,listen: false).uploadPostImage.path);
                        Provider.of<HomeHelper>(context,listen: false).addImages(galleryModel);
                        });
                    });
                    }
                    );
                  },)
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Gallery').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots()
                    ,builder: (context,snapshot){
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const CircularProgressIndicator();
                      }
                      else{
                        return GridView(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) => InkWell(
                          onDoubleTap: ()async{
                                await GallerySaver.saveImage(document['image'],toDcim: true);
                              },
                          onLongPress: (){
                            setState(() {
                              FirebaseFirestore.instance.collection('Gallery').doc(document.id).delete();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:CachedNetworkImage(imageUrl: document["image"],fit: BoxFit.cover,)),
                          ),
                        )
                        ).toList(),
                        );
                      }
                })
                // FutureBuilder(
                //   future: Provider.of<HomeHelper>(context,listen: false).getAllImages(),
                //   builder:(context,controller)=> GridView.builder(
                //     physics: const NeverScrollableScrollPhysics(),
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //     ),
                //     itemCount: Provider.of<HomeHelper>(context,listen: false).images.length,
                //     itemBuilder: (context,index){
                //       return InkWell(
                //         onLongPress: (){
                //           setState(() {
                //             Provider.of<HomeHelper>(context,listen: false).deleteImage(Provider.of<HomeHelper>(context,listen: false).images[index].image);
                //           });
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ClipRRect(
                //               borderRadius: BorderRadius.circular(15),
                //               child: Image.network(Provider.of<HomeHelper>(context,listen: false).images[index].image,fit: BoxFit.cover,)),
                //         ),
                //       );
                //     },),
                // )
            )
          ],
        ),
      ),
    );
  }
}
