class GalleryModel{
  String image;

  GalleryModel({required this.image});

  factory GalleryModel.fromMap(Map<dynamic,dynamic>map){
    return GalleryModel(image: map['image'] as String);
  }

  dynamic toMap(){
    return {
      'image' : this.image
    };
  }
}