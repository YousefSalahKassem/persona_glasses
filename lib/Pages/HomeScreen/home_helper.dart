import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persona/Model/gallery_model.dart';
import 'package:persona/Services/gallery_database.dart';
import 'dart:io';

class HomeHelper with ChangeNotifier{
List<GalleryModel> get images=>_images;
List<GalleryModel> _images=[];
late File uploadPostImage;
final picker=ImagePicker();

set images(List<GalleryModel> list){
  _images=list;
}

Future<List<GalleryModel>> getAllImages()async{
  var dbHelper=GalleryDatabaseHelper.db;
  _images=await dbHelper.getAllProduct();
  return _images;
}

addImages(GalleryModel galleryModel)async{
  _images.add(galleryModel);
  var dbHelper=GalleryDatabaseHelper.db;
  await dbHelper.insert(galleryModel);
  notifyListeners();
}

deleteImage(String image)async{
  var dbHelper=GalleryDatabaseHelper.db;
  await dbHelper.deleteProduct(image);
  notifyListeners();
}

Future pickUploadPostImage(BuildContext context,ImageSource source)async{
  final uploadPostImageVal=await picker.getImage(source: source);
  uploadPostImageVal==null?
  print('Select image')
      : uploadPostImage=File(uploadPostImageVal.path);

  notifyListeners();
}


}