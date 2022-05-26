import 'package:path/path.dart';
import 'package:persona/Constants/constants_text.dart';
import 'package:persona/Model/gallery_model.dart';
import 'package:sqflite/sqflite.dart';

class GalleryDatabaseHelper{

  GalleryDatabaseHelper._();
  static final GalleryDatabaseHelper db=GalleryDatabaseHelper._();
  static Database? _database;
  Future <Database?> get database async{
    if(_database != null) {
      return _database;
    }
    _database =await initDb();
    return _database;
  }

  initDb() async{
    String path=join(await getDatabasesPath(),'CartProduct.dp');
    return await openDatabase(path,version: 4,onCreate: (Database db,int version)async{
      await db.execute('''
      CREATE TABLE $galleryTable (
      $columnImage TEXT NOT NULL
      )
      ''');
    });
  }

  insert(GalleryModel model)async{
    var dbClient=await database;
    await dbClient!.insert(galleryTable, model.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future <List<GalleryModel>> getAllProduct() async{
    var dbClient=await database;
    List<Map>maps=await dbClient!.query(galleryTable);
    List<GalleryModel>list=maps.isNotEmpty?maps.map((prodcuts) => GalleryModel.fromMap(prodcuts)).toList():[];
    return list;
  }

  deleteProduct(String index)async{
    var dbClient=await database;
    return await dbClient!.rawDelete('DELETE FROM $galleryTable WHERE image = ?',[index],);
  }
}